<script lang="ts">
    import { formatDate, toKebabCase } from '$lib/utils';

    import Tag from '$lib/components/Tag.svelte';
    import type { PostSummary } from '$lib/posts';

    let {
        post,
        class: className = ''
    }: {
        post: PostSummary;
        /* Positioning and dividers are the caller's business — see posts/+page.svelte. */
        class?: string;
    } = $props();
</script>

<!-- Post preview card: date, title, summary, and up to three tags. -->
<div class={['relative', className]}>
    <div class="flex h-full flex-col font-monospace">
        <span class="text-[0.7rem] uppercase tracking-widest">
            {formatDate(post.publish_date)}
        </span>

        <!-- Card body: title and summary. -->
        <!-- Only the title is the link; ::after stretches its hit area over
             the whole card, so the accessible name stays just the title. -->
        <h2 class="text-balance leading-tight font-medium tracking-tight text-xl md:text-2xl">
            <!-- eslint-disable svelte/no-navigation-without-resolve -- post.href is resolved in posts.ts -->
            <a
                class="after:absolute after:inset-0 after:inset-be-8 after:content-['']"
                href={post.href}
            >
                {post.title}
            </a>
            <!-- eslint-enable svelte/no-navigation-without-resolve -->
        </h2>

        <p class="mt-2 line-clamp-3 text-pretty text-dim-foreground">
            {post.desc}
        </p>

        <div class="mt-2">
            <div class="flex flex-wrap gap-4 text-xs">
                {#each post.tags as tag (tag)}
                    <Tag tag={{ slug: tag, label: toKebabCase(tag) }} />
                {/each}
            </div>
        </div>
    </div>
</div>

<style>
    h2 {
        margin-top: 0.5rem;
    }
    a {
        border: 0;
    }
</style>
