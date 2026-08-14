import { type CheerioAPI, type Cheerio } from 'cheerio';
import type { Highlighter } from 'shiki';
import type { AnyNode } from 'domhandler';
import type { CodeBlock, FigureBlock, HtmlBlock, PostBlock, SideNoteBlock } from './types.ts';
import { CODE_FENCE_SELECTOR, SUPPORTED_LANGS, THEMES } from './constants.ts';
import { normalizeStretchy } from './math.ts';

function isSupportedLang(lang: string): boolean {
    return (SUPPORTED_LANGS as readonly string[]).includes(lang);
}

export function annotateStretchyMathFrames($: CheerioAPI) {
    $('math').each((_, el) => {
        normalizeStretchy($, el);
    });
}

export function collectBlocks(
    $: CheerioAPI,
    highlighter: Highlighter,
    warn: (message: string) => void,
    fileId: string
): PostBlock[] {
    const blocks: PostBlock[] = [];
    let codeIndex = 0;

    for (const node of $('body').contents().toArray() as AnyNode[]) {
        if (node.type === 'text') {
            const text = $(node).text().trim();
            if (text) {
                blocks.push(createHtmlBlock(`<p>${text}</p>`));
            }
            continue;
        }

        if (node.type !== 'tag') {
            continue;
        }

        const $node = $(node);

        if ($node.hasClass('side-note')) {
            blocks.push(createSideNoteBlock($node.html() ?? ''));
            continue;
        }
        if ($node.is('figure')) {
            const { id, content, caption } = extractFigureData($, $node);
            blocks.push(createFigureBlock({ id, content, caption }));
            continue;
        }

        const codeElement = $node.find(CODE_FENCE_SELECTOR);

        if (codeElement.length) {
            const codeBlock = createCodeBlock(
                codeElement,
                `codeblock-${codeIndex}`,
                highlighter,
                warn,
                fileId
            );
            if (codeBlock) {
                codeIndex += 1;
                blocks.push(codeBlock);
            }
            continue;
        }

        blocks.push(createHtmlBlock($.html(node) ?? ''));
    }

    return blocks;
}

function createHtmlBlock(html: string): HtmlBlock {
    return { type: 'html', html };
}

function createSideNoteBlock(content: string): SideNoteBlock {
    return { type: 'side-note', content };
}

function createFigureBlock({
    id,
    content,
    caption
}: {
    id?: string;
    content: string;
    caption?: string;
}): FigureBlock {
    return { type: 'figure', id: id, content, caption };
}

/**
 * Extract id, first-child HTML content, and optional caption HTML from a <figure> node.
 */
function extractFigureData(
    $: CheerioAPI,
    $node: Cheerio<AnyNode>
): { id: string; content: string; caption?: string } {
    const id = $node.attr('id') ?? '';
    const children = $node.children();
    const first = children.first();
    const content = first.length ? ($.html(first) ?? '') : '';
    const last = children.last();
    if (!last.is('figcaption')) {
        throw new Error(
            `Expected last child of <figure> to be <figcaption>, but got <${last[0].tagName}>`
        );
    }
    const caption = last.html() ?? undefined;

    return { id, content, caption };
}

function createCodeBlock(
    codeElement: Cheerio<AnyNode>,
    id: string,
    highlighter: Highlighter,
    warn: (message: string) => void,
    fileId: string
): CodeBlock | null {
    const source = codeElement.text();
    if (!source) {
        warn(`typst-to-svelte: empty <code> block "${id}" in ${fileId}`);
        return null;
    }

    const rawLang = codeElement.attr('data-lang') ?? '';
    const language = rawLang || 'plaintext';
    const highlightLang = isSupportedLang(rawLang) ? rawLang : 'plaintext';

    return {
        type: 'code',
        id,
        language,
        source,
        highlightedHtml: highlighter.codeToHtml(source, {
            lang: highlightLang,
            themes: THEMES
        })
    };
}
