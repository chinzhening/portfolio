<script lang="ts">
    import '$lib/css/article.css';

    import { title } from '$lib/config';
    import PostNavigation from '$lib/components/PostNavigation.svelte';
    import { components } from '$lib/components/article/components';
    import { getTagHref } from '$lib/posts';
    import { formatDate, toKebabCase } from '$lib/utils';
    import TypstRenderer from '$tyquire/svelte/TypstRenderer.svelte';

    import type { PageProps } from './$types';

    let { data }: PageProps = $props();
    let { metadata, children: nodes, prevPost, nextPost } = $derived(data);
</script>

<svelte:head>
    <title>{metadata.title} | {title}</title>
</svelte:head>

<div class="relative text-foreground min-h-screen">
    <main id="main" class="pt-8 pb-12 md:pt-16">
        <article class="container mx-auto max-w-4xl px-5 lg:px-20">
            <div class="mx-auto mb-4 border-b border-border pl-2">
                <header class="relative">
                    <!-- Post Title -->
                    <h1
                        class="relative font-monospace text-3xl font-medium tracking-tighter text-balance md:text-5xl"
                    >
                        {metadata.title}
                    </h1>

                    <!-- Description -->
                    {#if metadata.desc}
                        <p class="mt-2 font-monospace">{metadata.desc}</p>
                    {/if}

                    <!-- Tags -->
                    {#if metadata.tags.length}
                        <div class="mt-2 relative z-10 flex text-xs font-monospace">
                            <ul aria-label="Post tags" class="flex gap-3">
                                {#each metadata.tags as tag (tag)}
                                    <li
                                        class="
                                        border
                                        border-accent-cool hover:border-accent-warm
                                        hover:text-accent-warm text-accent-cool
                                    "
                                    >
                                        <!-- eslint-disable-next-line svelte/no-navigation-without-resolve -- getTagHref returns a resolved URL -->
                                        <a class="flex px-2 py-0.5" href={getTagHref(tag)}>
                                            {toKebabCase(tag)}
                                        </a>
                                    </li>
                                {/each}
                            </ul>
                        </div>
                    {/if}

                    <dl
                        class="relative z-10 mb-2 flex flex-col gap-2 py-4 text-sm font-monospace uppercase tracking-wider"
                    >
                        <div
                            class="
                            grid grid-cols-[3.75rem_minmax(0,1fr)]
                            items-center gap-2"
                        >
                            <dt>date:</dt>
                            <dd>
                                <time datetime={metadata.publish_date}
                                    >{formatDate(metadata.publish_date)}</time
                                >
                            </dd>
                        </div>
                        {#if metadata.edited_date}
                            <div
                                class="
                            grid grid-cols-[3.75rem_minmax(0,1fr)]
                            items-center gap-2"
                            >
                                <dt>edited:</dt>
                                <dd>
                                    <time datetime={metadata.edited_date}
                                        >{formatDate(metadata.edited_date)}</time
                                    >
                                </dd>
                            </div>
                        {/if}
                    </dl>
                </header>
            </div>

            <!-- Post Content -->
            <div class="typst mx-auto text-muted-foreground leading-relaxed">
                <svelte:boundary onerror={(error) => console.error('post render failed', error)}>
                    <TypstRenderer {nodes} {components} />

                    <!-- eslint-disable-next-line @typescript-eslint/no-unused-vars -->
                    {#snippet failed(error, reset)}
                        <p role="alert">
                            This post failed to render.
                            <button type="button" onclick={reset}>Try again</button>
                        </p>
                    {/snippet}
                </svelte:boundary>
            </div>
        </article>
    </main>
    <div class="container mx-auto px-6 max-w-3xl">
        <PostNavigation {prevPost} {nextPost} />
    </div>
</div>
