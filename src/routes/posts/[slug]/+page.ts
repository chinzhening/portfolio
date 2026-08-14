import { error } from '@sveltejs/kit';

import { getPrevAndNextPostLinks } from '$lib/posts';
import type { PostMetadata } from '$lib/types';
import type { TypstDocument } from '$tyquire';

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

type PostDocument = TypstDocument<PostMetadata>;

async function importPostDocument(slug: string): Promise<PostDocument> {
    const module = await import(`../../../lib/content/${slug}.typ`);
    return module.default as PostDocument;
}
