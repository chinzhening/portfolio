import { createHighlighter, type Highlighter } from 'shiki';
import { SUPPORTED_LANGS, THEMES } from './constants.ts';

export function createTyquireHighlighter(): Promise<Highlighter> {
    return createHighlighter({
        themes: [THEMES.light, THEMES.dark],
        langs: [...SUPPORTED_LANGS]
    });
}
