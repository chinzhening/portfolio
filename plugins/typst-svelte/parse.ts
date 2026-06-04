import { type CheerioAPI, type Cheerio } from 'cheerio'
import type { Highlighter } from 'shiki'
import type { AnyNode } from 'domhandler'
import type { CodeBlock, FigureBlock, HtmlBlock, PostBlock, SideNoteBlock } from '$lib/types'
import { RAW_SOURCE_SELECTOR, CODE_FENCE_SELECTOR, SUPPORTED_LANGS, THEMES } from './constants'

interface CodeElementLike { attr(name: string): string | undefined }

function isSupportedLang(lang: string): boolean {
    return (SUPPORTED_LANGS as readonly string[]).includes(lang)
}

export function normalizeMathFrames($: CheerioAPI) {
    $('svg.typst-frame use').each((_, el) => {
        $(el).attr('fill', 'currentColor')
    })

    $('svg.typst-frame path.typst-shape').each((_, el) => {
        $(el).attr('stroke', 'currentColor')
    })
}

export function collectRawSourceByLabel($: CheerioAPI): Map<string, string> {
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

export function collectBlocks(
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

        if ($node.hasClass('side-note')) {
            blocks.push(createSideNoteBlock($node.html() ?? ''))
            continue
        }
        if ($node.is('figure')) {
            const { id, content, caption } = extractFigureData($, $node)
            blocks.push(createFigureBlock({ id, content, caption }))
            continue
        }

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

export function createHtmlBlock(html: string): HtmlBlock {
    return { type: 'html', html }
}

export function createSideNoteBlock(content: string): SideNoteBlock {
    return { type: 'side-note', content }
}

export function createFigureBlock({ id, content, caption }: { id?: string, content: string, caption?: string }): FigureBlock {
    return { type: 'figure', id: id, content, caption }
}

/**
 * Extract id, first-child HTML content, and optional caption HTML from a <figure> node.
 */
export function extractFigureData($: CheerioAPI, $node: Cheerio<AnyNode>): { id: string; content: string; caption?: string } {
    const id = $node.attr('id') ?? ''
    const children = $node.children()
    const first = children.first()
    const content = first.length ? $.html(first) ?? '' : ''
    const last = children.last()
    if (!last.is('figcaption')) {
        throw new Error(`Expected last child of <figure> to be <figcaption>, but got <${last[0].tagName}>`)
    }
    const caption = last.html() ?? undefined
    
    return { id, content, caption }
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
