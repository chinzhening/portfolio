<script lang="ts">
    import { browser } from '$app/environment';
    import { page } from '$app/state';
    import Seo from '$lib/components/Seo.svelte';
    import { getPostsByTag, getTagLabel, normalizeTag } from '$lib/posts';
    import Tag from '$lib/components/Tag.svelte';
    import { formatDate } from '$lib/utils';
    import type { PageProps } from './$types';

    let { data }: PageProps = $props();
    let requestedTag = $derived(browser ? (page.url.searchParams.get('tag') ?? '') : '');
    let selectedTag = $derived(normalizeTag(requestedTag));
    let selectedLabel = $derived(selectedTag ? getTagLabel(data.posts, selectedTag) : null);
    let matchingPosts = $derived(getPostsByTag(data.posts, selectedTag));
</script>

<Seo title="Tags" path="/tags" />

<main id="main">
    <div class="mx-auto max-w-3xl px-6 pb-20">
        <section class="mt-8 md:mt-12 text-md font-monospace text-dim-foreground">
            <p>```</p>
            <p class="text-foreground">
                {#if selectedLabel}
                    Posts tagged <span class="text-accent-warm">{selectedLabel}</span>.
                {:else}
                    Browse posts by topic.
                {/if}
            </p>
            <p class="mt-2">```</p>
        </section>

        <hr class="mt-4 border-border/50" />

        <section class="mt-8 font-monospace" aria-labelledby="available-tags">
            <ul class="flex flex-wrap gap-3" aria-label="Available tags">
                {#each data.tags as tag (tag.slug)}
                    <li>
                        <Tag {tag} active={tag.slug === selectedTag} />
                    </li>
                {:else}
                    <li class="text-dim-foreground">No tags found.</li>
                {/each}
            </ul>
        </section>

        <section class="mt-8" aria-labelledby="matching-posts">
            <div class="flex items-center justify-between gap-4">
                <h2 id="matching-posts" class="section-heading">= posts</h2>
                <span
                    class="font-monospace text-xs uppercase tracking-widest text-faint-foreground"
                >
                    {matchingPosts.length}
                    {matchingPosts.length === 1 ? 'entry' : 'entries'}
                </span>
            </div>

            <ul class="mt-4 border-y border-border/50">
                {#each matchingPosts as post (post.slug)}
                    <li class="border-b border-border/50 last:border-b-0">
                        <!-- eslint-disable svelte/no-navigation-without-resolve -- post.href is resolved in posts.ts -->
                        <a
                            class="grid grid-cols-1 gap-1 pl-4 py-2 font-monospace text-foreground transition-colors focus-visible:text-accent-warm sm:grid-cols-[4rem_minmax(0,1fr)] sm:items-baseline sm:gap-4"
                            href={post.href}
                        >
                            <time class="text-xs text-dim-foreground" datetime={post.publish_date}
                                >{formatDate(post.publish_date)}</time
                            >
                            <span>{post.title}</span>
                        </a>
                        <!-- eslint-enable svelte/no-navigation-without-resolve -->
                    </li>
                {:else}
                    <li class="py-4 text-dim-foreground">No matching posts.</li>
                {/each}
            </ul>
        </section>
    </div>
</main>
