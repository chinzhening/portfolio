import { error } from '@sveltejs/kit';

import { getPrevAndNextPostLinks } from '$lib/posts';
import type { PostMetadata } from '$lib/types';
import type { TypstNode } from '$tyquire';

export async function load({ params, parent }) {
    try {
        const { metadata, children } = await importPostDocument(params.slug);
        const { posts } = await parent();
        const { prevPost, nextPost } = getPrevAndNextPostLinks(posts, params.slug);
        return {
            metadata,
            children,
            prevPost,
            nextPost
        };
    } catch {
        error(404);
    }
}

interface PostDocument {
    metadata: PostMetadata;
    children: TypstNode[];
}

async function importPostDocument(slug: string): Promise<PostDocument> {
    const module = await import(`../../../lib/content/${slug}.typ`);
    return { metadata: module.metadata as PostMetadata, children: module.default as TypstNode[] };
}
