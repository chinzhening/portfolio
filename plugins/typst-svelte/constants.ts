export const RAW_SOURCE_SELECTOR = 'script[type="text/plain"][data-typst-label]'
export const CODE_FENCE_SELECTOR = 'pre code[data-typst-label]'

export const SUPPORTED_LANGS = [
    'css',
    'python',
    'javascript',
    'rust',
    'typst',
    'cpp',
    'c',
    'svelte',
    
] as const

export const THEMES = { light: 'min-light', dark: 'everforest-dark' }
