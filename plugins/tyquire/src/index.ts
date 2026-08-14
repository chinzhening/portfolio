import type { Plugin } from 'vite';
import type { Highlighter } from 'shiki';
import { load } from 'cheerio';

import { getHighlighter } from './highlight.ts';
import { compile, query } from './runner.ts';
import { annotateStretchyMathFrames, walkDocument } from './parse.ts';
import type { TypstDocument } from './types.ts';

export type * from './types.ts';

export default function typstToSvelte(): Plugin {
    let highlighter: Highlighter;
    return {
        name: 'typst-to-svelte',
        enforce: 'pre',

        async buildStart() {
            highlighter = await getHighlighter();
        },

        async transform(code, id) {
            if (!id.endsWith('.typ')) return;

            const source = String(code);
            const warn = this.warn.bind(this);

            const [html, { metadata, count }] = await Promise.all([compile(source, id), query(id)]);

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
        },
        handleHotUpdate({ server, file }) {
            if (!file.includes('content/') || !file.endsWith('.typ')) {
                return;
            }

            const module = server.moduleGraph.getModuleById(file);
            if (module) {
                server.reloadModule(module);
                return [];
            }
        },
        buildEnd() {
            highlighter?.dispose();
        }
    };
}
