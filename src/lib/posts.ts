import { resolve } from '$app/paths'

import type { PostMetadata } from '$lib/types'

export interface PostSummary extends PostMetadata {
	slug: string
	href: string
}

export function getPosts(): PostSummary[] {
	const modules = import.meta.glob<{ default: { html: string; metadata: PostMetadata } }>(
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

	posts.sort((a, b) => new Date(b.publish_date).getTime() - new Date(a.publish_date).getTime())

	const publishedPosts = posts.filter((post) => post.published === 'true')

	return publishedPosts
}

export function getPrevAndNextPostLinks(
	posts: PostSummary[],
	slug: string
): { prevPost: PostSummary | null; nextPost: PostSummary | null } {
	const index = posts.findIndex((post) => post.slug === slug)

	return {
		prevPost: index < posts.length - 1 ? posts[index + 1] : null,
		nextPost: index > 0 ? posts[index - 1] : null
	}
}