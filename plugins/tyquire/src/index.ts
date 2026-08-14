import type { Plugin } from 'vite';
import type { Highlighter } from 'shiki';
import { load } from 'cheerio';
import type { PostDocument } from '$lib/types';

import { getHighlighter } from './highlight';
import { compile, query } from './runner';
import { annotateStretchyMathFrames, collectRawSourceByLabel, collectBlocks } from './parse';

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
            const [html, metadata] = await Promise.all([compile(source, id), query(id)]);

            const $ = load(html);

            annotateStretchyMathFrames($);

            const rawSourceByLabel = collectRawSourceByLabel($);
            const blocks = collectBlocks(
                $,
                highlighter,
                rawSourceByLabel,
                this.warn.bind(this),
                id
            );

            const document: PostDocument = { metadata, blocks };

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
