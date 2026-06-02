import { error } from '@sveltejs/kit'

import { getPrevAndNextPostLinks } from '$lib/posts'
import type { PostDocument } from '$lib/types'

export async function load({ params, parent }) {
    try {
        const { metadata, blocks } = await importPostDocument(params.slug)
        const { posts } = await parent()
        const { prevPost, nextPost } = getPrevAndNextPostLinks(posts, params.slug)
        return {
            metadata,
            blocks,
            prevPost,
            nextPost,
        }
    } catch {
        error(404)
    }
}

async function importPostDocument(slug: string): Promise<PostDocument> {
    const module = await import(`../../../lib/content/${slug}.typ`)
    return module.default as PostDocument
}
