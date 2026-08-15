import type { Plugin } from 'vite';
import type { Highlighter } from 'shiki';
import { load } from 'cheerio';

import { createTyquireHighlighter } from './highlight.ts';
import { compile, query } from './runner.ts';
import { annotateStretchyMathFrames, walkDocument } from './parse.ts';
import type { TypstDocument } from './types.ts';

export type * from './types.ts';

export default function tyquire(): Plugin {
    let highlighter: Highlighter;
    let root = '';
    return {
        name: 'tyquire',
        enforce: 'pre',

        configResolved(config) {
            root = config.root;
        },
        async buildStart() {
            highlighter = await createTyquireHighlighter();
        },

        transform: {
            filter: { id: /\.typ$/ },
            async handler(code, id) {
                const source = String(code);
                const warn = this.warn.bind(this);

                const [{ html, deps }, { metadata, count }] = await Promise.all([
                    compile(source, id),
                    query(id)
                ]);

                for (const dep of deps) {
                    const normalized = dep.replace(/^\\\\\?\\/, '').replace(/\\/g, '/');
                    if (normalized.endsWith('/<stdin>') || normalized === '<stdin>') continue;
                    if (normalized.startsWith(root)) {
                        this.addWatchFile(normalized);
                    }
                }

                if (count > 1) {
                    warn(`tyquire: ${count} <metadata> found in ${id}, using the first`);
                }

                const $ = load(html);
                annotateStretchyMathFrames($);

                const document: TypstDocument = {
                    metadata,
                    children: walkDocument($, { highlighter, warn, fileId: id })
                };

                return `export default ${JSON.stringify(document)};`;
            }
        },
        hotUpdate({ modules }) {
            return modules;
        },
        buildEnd() {
            highlighter?.dispose();
        }
    };
}
