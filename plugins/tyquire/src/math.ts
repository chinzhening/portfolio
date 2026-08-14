import type { CheerioAPI } from 'cheerio';
import type { AnyNode } from 'domhandler';

const DELIMITERS = new Map<string, string>([
    ['(', ')'],
    ['[', ']'],
    ['{', '}'],
    ['⌈', '⌉'],
    ['⌊', '⌋'],
    ['⟨', '⟩']
]);

const TALL_TAGS = new Set([
    'mfrac',
    'msqrt',
    'mroot',
    'mtable',
    'munder',
    'mover',
    'munderover',
    'mmultiscripts'
]);

const TALL_SELECTOR = Array.from(TALL_TAGS).join(',');

type TagNode = AnyNode & { tagName: string; children: AnyNode[] };

function isTag(node: AnyNode): node is TagNode {
    return node.type === 'tag';
}

export function normalizeStretchy($: CheerioAPI, root?: AnyNode): void {
    const startNode = root ?? $.root()[0];

    if (isTag(startNode)) {
        visit(startNode);
    } else if ('children' in startNode) {
        for (const child of startNode.children as AnyNode[]) {
            if (isTag(child)) visit(child);
        }
    }

    function visit(node: TagNode): void {
        processContainer(node);

        for (const child of node.children) {
            if (isTag(child)) {
                visit(child);
            }
        }
    }

    function processContainer(container: TagNode): void {
        const children = $(container).children().toArray().filter(isTag);

        for (let i = 0; i < children.length; i++) {
            const open = children[i];

            if (open.tagName !== 'mo') continue;

            const openText = $(open).text().trim();
            const closeText = DELIMITERS.get(openText);
            if (!closeText) continue;

            let depth = 1;

            for (let j = i + 1; j < children.length; j++) {
                const current = children[j];

                if (current.tagName !== 'mo') continue;

                const text = $(current).text().trim();

                if (text === openText) {
                    depth++;
                } else if (text === closeText) {
                    depth--;

                    if (depth !== 0) continue;

                    const enclosed = children.slice(i + 1, j);

                    const hasTallContent = enclosed.some(
                        (el) => TALL_TAGS.has(el.tagName) || $(el).find(TALL_SELECTOR).length > 0
                    );

                    if (!hasTallContent) {
                        if ($(open).attr('stretchy') == null) {
                            $(open).attr('stretchy', 'false');
                        }
                        if ($(current).attr('stretchy') == null) {
                            $(current).attr('stretchy', 'false');
                        }
                    }

                    break;
                }
            }
        }
    }
}
