<script lang="ts">
    import { resolve } from '$app/paths';
    import { formatDate, toKebabCase } from '$lib/utils';

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
        <!-- Card header: publish date and open indicator. -->
        <div class="flex">
            <span class="text-[0.7rem] uppercase tracking-widest text-accent-warm">
                {formatDate(post.publish_date)}
            </span>
        </div>

        <!-- Card body: title and summary. -->
        <!-- Only the title is the link; ::after stretches its hit area over
             the whole card, so the accessible name stays just the title. -->
        <h2 class="mt-1 text-balance leading-tight font-medium tracking-tight text-xl md:text-2xl">
            <!-- eslint-disable-next-line svelte/no-navigation-without-resolve -- already resolved, in posts.ts:20 -->
            <a
                class="after:absolute after:inset-0 after:inset-be-8 after:content-['']"
                href={post.href}
            >
                {post.title}
            </a>
        </h2>

        <p class="mt-2 line-clamp-3 text-pretty text-dim-foreground">
            {post.desc}
        </p>

        <div class="mt-2">
            <div class="flex flex-wrap gap-4 text-xs">
                {#each post.tags as tag (tag)}
                    <div
                        class="
                    border
                        border-accent-cool hover:border-accent-warm
                        hover:text-accent-warm text-accent-cool
                    "
                    >
                        <a class="flex px-2 py-0.5" href={resolve('/')}>
                            {toKebabCase(tag)}
                        </a>
                    </div>
                {/each}
            </div>
        </div>
    </div>
</div>
