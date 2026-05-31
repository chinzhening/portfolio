import type { Plugin } from 'vite'
import { spawn } from 'child_process'
import { createHighlighter, type Highlighter } from 'shiki'
import { load } from 'cheerio'
import { dirname } from 'path'

const fontPath = process.env.TYPST_FONT_PATH
const SUPPORTED_LANGS = ['css', 'python', 'javascript', 'rust', 'typst', 'cpp', 'c'] as const
const THEMES = {
    light: 'min-light',
    dark: 'everforest-dark',
}
type SupportedLang = typeof SUPPORTED_LANGS[number]

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

            const source = `${code}`
            const [html, metadata] = await Promise.all([
                compile(source, id),
                query(id),
            ])

            const $ = load(html)

            // Fix math frames to use currentColor for stroke and fill, so they 
            // can be styled with CSS
            $('svg.typst-frame use').each((_, el) => {
                $(el).attr('fill', 'currentColor')
            })
            $('svg.typst-frame path.typst-shape').each((_, el) => {
                $(el).attr('stroke', 'currentColor')
            })

            // Pass 1: collect raw source blocks keyed by label
            const rawMap = new Map<string, string>()

            $('script[type="text/plain"][data-typst-label]').each((_, el) => {
                const $el = $(el)
                const label = $el.attr('data-typst-label')!
                rawMap.set(label, $el.text())
                $el.remove()
            })

            // Pass 2: replace <pre><code> blocks with highlighted HTML
            $('pre code[data-typst-label]').each((_, el) => {
                const $code = $(el)

                const label = $code.attr('data-typst-label')!
                if (!label) {
                    this.warn('typst-to-svelte: <code> block missing data-typst-label in ${id}')
                    return
                }
                
                const raw = rawMap.get(label)
                if (!raw) {
                    this.warn('typst-to-svelte: no raw source found for label "${label}" in ${id}')
                    return
                }

                const rawLang = $code.attr('data-lang') ?? ''
                const lang = isSupportedLang(rawLang) ? rawLang : 'plaintext'

                const highlighted = highlighter.codeToHtml(raw, {
                    lang,
                    themes: THEMES,
                })

                $code.parent().replaceWith(`<div class="code-title"><span>${lang}</span></div>${highlighted}`)
            })

            const body = $('body').html()

            const output = `<div class="typst">\n${body}\n</div>`

            return `export default ${JSON.stringify({ html: output, metadata })}`;
        },
        handleHotUpdate({ server, file }) {
        if (file.includes('content/') && file.endsWith('.typ')) {
            const thisModule = server.moduleGraph.getModuleById(file)
            if (thisModule) {
                server.reloadModule(thisModule)
                return []
            }
        }
        },
        buildEnd() {
            highlighter?.dispose()
        }
    }
}

function compile(source: string, id: string): Promise<string> {

    return new Promise((resolve, reject) => {
        const child = spawn('typst', [
            'compile',
            '--features', 'html',
            '--format', 'html',
            ...(fontPath ?['--font-path', fontPath] : []),
            '-', '-'
        ], { cwd: dirname(id) },
        )
        child.stdin.write(source)
        child.stdin.end()
        
        const chunks: Buffer[] = []
        child.stdout?.on('data', (chunk: Buffer) => { chunks.push(chunk) })
        child.stderr?.on('data', (data: Buffer) => {
            console.error(`[typst-to-svelte] ${data.toString().trim()}`)
        })

        child.on('close', (code) => {
            if (code !== 0) {
                reject(new Error(`typst exited with code ${code} for file ${id}`))
            } else {
                resolve(Buffer.concat(chunks).toString('utf8'))
            }
        })

        child.on('error', reject)
    })
}


interface PostMetadata {
    title: string
    desc: string
    published: string
    updated?: string
    tags: string[]
}

function query(id: string): Promise<PostMetadata> {
    return new Promise((resolve, reject) => {
        const child = spawn('typst', [
            'query',
            '--features', 'html',
            id, '<metadata>'],
            { cwd: dirname(id) }
        )

        const chunks: Buffer[] = []
        child.stdout?.on('data', (chunk: Buffer) => chunks.push(chunk))
        child.stderr?.on('data', (data: Buffer) => {
            console.error(`[typst-to-svelte] ${data.toString().trim()}`)
        })

        child.on('close', (code) => {
            if (code !== 0) {
                reject(new Error(`typst query exited with code ${code} for file ${id}`))
            } else {
                const raw = Buffer.concat(chunks).toString('utf8')
                const results = JSON.parse(raw)
                resolve(results[0].value as PostMetadata)
            }
        })

        child.on('error', reject)
    })
}