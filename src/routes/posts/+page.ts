import type { PostMetadata } from '$lib/types'
import { resolve } from '$app/paths';

// src/routes/posts/+page.ts
export async function load() {
    const modules = import.meta.glob<{ default: { html: string, metadata: PostMetadata } }>(
        '$lib/content/*.typ',
        { eager: true }
    )

    const posts = Object.entries(modules).map(([path, mod]) => {
        const slug = path.split('/').at(-1)!.replace('.typ', '')
        return {
            slug,
            href: resolve(`/posts/${slug}`),
            ...mod.default.metadata
        }
    })

    // sort by date descending
    posts.sort((a, b) => new Date(b.published).getTime() - new Date(a.published).getTime())

    return { posts }
}