import { resolve } from '$app/paths';

import type { PostMetadata } from '$lib/types';
import { toKebabCase } from '$lib/utils';

export interface PostSummary extends PostMetadata {
    slug: string;
    href: string;
}

export interface TagSummary {
    slug: string;
    label: string;
    count: number;
}

export function getPosts(): PostSummary[] {
    const modules = import.meta.glob<{ metadata: PostMetadata }>('$lib/content/*.typ', {
        eager: true
    });

    const posts = Object.entries(modules).map(([path, mod]) => {
        const slug = path.split('/').at(-1)!.replace('.typ', '');
        return {
            slug,
            href: resolve(`/posts/${slug}`),
            ...mod.metadata
        };
    });

    const publishedPosts = posts.filter((post) => post.published);

    publishedPosts.sort(
        (a, b) => new Date(b.publish_date).getTime() - new Date(a.publish_date).getTime()
    );

    return publishedPosts;
}

export function getPrevAndNextPostLinks(
    posts: PostSummary[],
    slug: string
): { prevPost: PostSummary | null; nextPost: PostSummary | null } {
    const index = posts.findIndex((post) => post.slug === slug);

    return {
        nextPost: index < posts.length - 1 ? posts[index + 1] : null,
        prevPost: index > 0 ? posts[index - 1] : null
    };
}

export function normalizeTag(tag: string): string {
    return toKebabCase(tag);
}

export function getTagHref(tag: string): string {
    return `${resolve('/tags')}?tag=${encodeURIComponent(normalizeTag(tag))}`;
}

export function getPostsByTag(posts: PostSummary[], tag: string): PostSummary[] {
    const normalizedTag = normalizeTag(tag);
    if (!normalizedTag) {
        return [];
    }

    return posts.filter((post) => post.tags.some((t) => normalizeTag(t) === normalizedTag));
}

export function getTagSummaries(posts: PostSummary[]): TagSummary[] {
    const tagMap = new Map<
        string,
        {
            count: number;
            labels: Map<string, { count: number; firstSeen: number }>;
        }
    >();
    let firstSeen = 0;

    for (const post of posts) {
        const postTags = new Set<string>();

        for (const tag of post.tags) {
            const normalizedTag = normalizeTag(tag);
            if (!normalizedTag || postTags.has(normalizedTag)) {
                continue;
            }
            postTags.add(normalizedTag);

            let summary = tagMap.get(normalizedTag);
            if (!summary) {
                summary = { count: 0, labels: new Map() };
                tagMap.set(normalizedTag, summary);
            }

            summary.count++;

            const label = summary.labels.get(tag);
            if (label) {
                label.count++;
            } else {
                summary.labels.set(tag, { count: 1, firstSeen });
            }
            firstSeen++;
        }
    }

    return [...tagMap.entries()]
        .map(([slug, summary]) => {
            const label = [...summary.labels.entries()].sort(
                ([, a], [, b]) => b.count - a.count || a.firstSeen - b.firstSeen
            )[0][0];

            return { slug, label, count: summary.count };
        })
        .sort((a, b) => a.label.localeCompare(b.label));
}

export function getTagLabel(posts: PostSummary[], tag: string): string | null {
    const normalizedTag = normalizeTag(tag);
    return getTagSummaries(posts).find((summary) => summary.slug === normalizedTag)?.label ?? null;
}
