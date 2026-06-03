import type { Plugin } from 'vite'
import { compile, query, getHighlighter } from './typst-svelte/index'
import type { Highlighter } from 'shiki'
import { SUPPORTED_LANGS, THEMES } from './typst-svelte/constants'
import { load } from 'cheerio'
import type { PostDocument } from '$lib/types'


export default function typstToSvelte(): Plugin {
    let highlighter: Highlighter
    return {
        name: 'typst-to-svelte',
        enforce: 'pre',

        async buildStart() {
            highlighter = await getHighlighter()
        },

        async transform(code, id) {
            if (!id.endsWith('.typ')) return;

            const source = String(code)
            const [html, metadata] = await Promise.all([
                compile(source, id),
                query(id),
            ])

            const $ = load(html)
            // parsing helpers
            const { normalizeMathFrames, collectRawSourceByLabel, collectBlocks } = await import('./typst-svelte/parse')

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

// parsing helpers are implemented in ./typst-svelte/parse