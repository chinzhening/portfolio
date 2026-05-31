export interface PostMetadata {
    title: string
    desc: string
    published: string
    updated?: string
    tags: string[]
}

export interface HtmlBlock {
    type: 'html'
    html: string
}

export interface CodeBlock {
    type: 'code'
    id: string
    language: string
    source: string
    highlightedHtml: string
}

export type PostBlock = HtmlBlock | CodeBlock

export interface PostDocument {
    metadata: PostMetadata
    blocks: PostBlock[]
}