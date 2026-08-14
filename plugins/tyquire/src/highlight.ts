import { createHighlighter, type Highlighter } from 'shiki';
import { SUPPORTED_LANGS, THEMES } from './constants.ts';

let cached: Highlighter | null = null;

/**
 * Initialize and return a singleton Highlighter using project defaults.
 * Calling `getHighlighter()` multiple times returns the cached instance.
 */
export async function getHighlighter(): Promise<Highlighter> {
    if (cached) return cached;
    cached = await createHighlighter({
        themes: [THEMES.light, THEMES.dark],
        langs: [...SUPPORTED_LANGS]
    });
    return cached;
}
