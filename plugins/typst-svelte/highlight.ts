import { createHighlighter, type Highlighter } from 'shiki'
import { SUPPORTED_LANGS, THEMES } from './constants'

let cached: Highlighter | null = null

/**
 * Initialize and return a singleton Highlighter using project defaults.
 * Calling `getHighlighter()` multiple times returns the cached instance.
 */
export async function getHighlighter(): Promise<Highlighter> {
    if (cached) return cached
    cached = await createHighlighter({ themes: [THEMES.light, THEMES.dark], langs: [...SUPPORTED_LANGS] })
    return cached
}

/**
 * Backwards-compatible setup function that accepts custom options.
 */
export async function setupHighlighter(opts: { themes: string[]; langs: string[] }): Promise<Highlighter> {
    if (cached) return cached
    cached = await createHighlighter({ themes: opts.themes, langs: opts.langs })
    return cached
}

export type { Highlighter }
