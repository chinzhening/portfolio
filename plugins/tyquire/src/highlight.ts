import { createHighlighter, type Highlighter } from 'shiki';
import { SUPPORTED_LANGS, THEMES } from './constants.ts';

let cached: Highlighter | null = null;

/**
 * A process-wide Highlighter, since creating one costs a WASM load.
 *
 * The cache outlives `buildEnd`'s `dispose()`, so a second build in the same
 * process gets a disposed instance. Fixed by per-environment state in Phase 4.
 */
export async function getHighlighter(): Promise<Highlighter> {
    if (cached) return cached;
    cached = await createHighlighter({
        themes: [THEMES.light, THEMES.dark],
        langs: [...SUPPORTED_LANGS]
    });
    return cached;
}
