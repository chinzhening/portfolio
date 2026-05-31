import type { Plugin } from 'vite'
import { spawn } from 'child_process'
import { createHighlighter, type Highlighter } from 'shiki'
import { load, type CheerioAPI } from 'cheerio'
import type { AnyNode } from 'domhandler'
import { dirname } from 'path'
import type { CodeBlock, HtmlBlock, PostBlock, PostDocument, PostMetadata } from '$lib/types'

const fontPath = process.env.TYPST_FONT_PATH
const SUPPORTED_LANGS = ['css', 'python', 'javascript', 'rust', 'typst', 'cpp', 'c', 'svelte'] as const
const THEMES = {
    light: 'min-light',
    dark: 'everforest-dark',
}
const RAW_SOURCE_SELECTOR = 'script[type="text/plain"][data-typst-label]'
const CODE_FENCE_SELECTOR = 'pre code[data-typst-label]'

type SupportedLang = typeof SUPPORTED_LANGS[number]

interface CodeElementLike {
    attr(name: string): string | undefined
}

function isSupportedLang(lang: string): lang is SupportedLang {
    return (SUPPORTED_LANGS as readonly string[]).includes(lang)
}

export default function typstToSvelte(): Plugin {
    let highlighter: Highlighter
    return {
        name: 'typst-to-svelte',
        enforce: 'pre',

        async buildStart() {
            highlighter = await createHighlighter({
                themes: [THEMES.light, THEMES.dark],
                langs: [...SUPPORTED_LANGS],
            })
        },

        async transform(code, id) {
            if (!id.endsWith('.typ')) return;

            const source = String(code)
            const [html, metadata] = await Promise.all([
                compile(source, id),
                query(id),
            ])

            const $ = load(html)
            normalizeMathFrames($)

            const rawSourceByLabel = collectRawSourceByLabel($)
            const blocks = collectBlocks($, highlighter, rawSourceByLabel, this.warn.bind(this), id)

            const document: PostDocument = { metadata, blocks }

            return `export default ${JSON.stringify(document)};`
        },
        handleHotUpdate({ server, file }) {
            if (!file.includes('content/') || !file.endsWith('.typ')) {
                return
            }

            const module = server.moduleGraph.getModuleById(file)
            if (module) {
                server.reloadModule(module)
                return []
            }
        },
        buildEnd() {
            highlighter?.dispose()
        }
    }
}

function normalizeMathFrames($: CheerioAPI) {
    $('svg.typst-frame use').each((_, el) => {
        $(el).attr('fill', 'currentColor')
    })

    $('svg.typst-frame path.typst-shape').each((_, el) => {
        $(el).attr('stroke', 'currentColor')
    })
}

function collectRawSourceByLabel($: CheerioAPI): Map<string, string> {
    const rawSourceByLabel = new Map<string, string>()

    $(RAW_SOURCE_SELECTOR).each((_, el) => {
        const $el = $(el)
        const label = $el.attr('data-typst-label')

        if (!label) return

        rawSourceByLabel.set(label, $el.text())
        $el.remove()
    })

    return rawSourceByLabel
}

function collectBlocks(
    $: CheerioAPI,
    highlighter: Highlighter,
    rawSourceByLabel: Map<string, string>,
    warn: (message: string) => void,
    fileId: string,
): PostBlock[] {
    const blocks: PostBlock[] = []

    for (const node of $('body').contents().toArray() as AnyNode[]) {
        if (node.type === 'text') {
            const text = $(node).text().trim()
            if (text) {
                blocks.push(createHtmlBlock(`<p>${text}</p>`))
            }
            continue
        }

        if (node.type !== 'tag') {
            continue
        }

        const $node = $(node)
        const codeElement = $node.find(CODE_FENCE_SELECTOR)

        if (codeElement.length) {
            const codeBlock = createCodeBlock(codeElement, highlighter, rawSourceByLabel, warn, fileId)
            if (codeBlock) {
                blocks.push(codeBlock)
            }
            continue
        }

        blocks.push(createHtmlBlock($.html(node) ?? ''))
    }

    return blocks
}

function createHtmlBlock(html: string): HtmlBlock {
    return { type: 'html', html }
}

function createCodeBlock(
    codeElement: CodeElementLike,
    highlighter: Highlighter,
    rawSourceByLabel: Map<string, string>,
    warn: (message: string) => void,
    fileId: string,
): CodeBlock | null {
    const label = codeElement.attr('data-typst-label')
    if (!label) {
        warn(`typst-to-svelte: <code> block missing data-typst-label in ${fileId}`)
        return null
    }

    const source = rawSourceByLabel.get(label)
    if (!source) {
        warn(`typst-to-svelte: no raw source found for label "${label}" in ${fileId}`)
        return null
    }

    const rawLang = codeElement.attr('data-lang') ?? ''
    const language = rawLang || 'plaintext'
    const highlightLang = isSupportedLang(rawLang) ? rawLang : 'plaintext'

    return {
        type: 'code',
        id: label,
        language,
        source,
        highlightedHtml: highlighter.codeToHtml(source, {
            lang: highlightLang,
            themes: THEMES,
        }),
    }
}

function runTypst(args: string[], cwd: string, input?: string): Promise<string> {
    return new Promise((resolve, reject) => {
        const child = spawn('typst', args, { cwd })

        if (input !== undefined) {
            child.stdin.write(input)
        }
        child.stdin.end()

        const chunks: Buffer[] = []
        child.stdout?.on('data', (chunk: Buffer) => {
            chunks.push(chunk)
        })
        child.stderr?.on('data', (data: Buffer) => {
            console.error(`[typst-to-svelte] ${data.toString().trim()}`)
        })

        child.on('close', (code) => {
            if (code !== 0) {
                reject(new Error(`typst exited with code ${code}`))
                return
            }

            resolve(Buffer.concat(chunks).toString('utf8'))
        })

        child.on('error', reject)
    })
}

function compile(source: string, id: string): Promise<string> {
    return runTypst([
        'compile',
        '--features', 'html',
        '--format', 'html',
        ...(fontPath ? ['--font-path', fontPath] : []),
        '-', '-'
    ], dirname(id), source)
}

function query(id: string): Promise<PostMetadata> {
    return runTypst([
        'query',
        '--features', 'html',
        id,
        '<metadata>',
    ], dirname(id)).then((raw) => {
        const results = JSON.parse(raw)
        return results[0].value as PostMetadata
    })
}