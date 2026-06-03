export interface PostMetadata {
    title: string
    desc: string
    published: "true" | "false"
    publish_date: string
    edited_date?: string
    tags: string[]
}

export interface HtmlBlock {
    type: 'html';
    html: string;
}

export interface CodeBlock {
    type: 'code';
    id: string;
    language: string;
    source: string;
    highlightedHtml: string;
}

export interface FigureBlock {
    /** Discriminant for block unions */
    type: 'figure';
    /** Optional id attribute from the source figure */
    id?: string;
    /** Raw HTML content for the figure (may include inline SVG) */
    content: string;
    /** Optional caption HTML (already HTML-escaped/ready) */
    caption?: string;
}

export interface SideNoteBlock {
    type: 'side-note';
    content: string;
}

export type PostBlock = HtmlBlock | CodeBlock | FigureBlock | SideNoteBlock 

export interface PostDocument {
    metadata: PostMetadata;
    blocks: PostBlock[];
}