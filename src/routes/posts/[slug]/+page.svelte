<script lang="ts">
    import '$lib/css/article.css';
    import '$lib/css/shiki.css';

    import { resolve } from '$app/paths';
    import { title } from '$lib/config';

    import CodeBlock from '$lib/components/CodeBlock.svelte';
    import FigureBlock from '$lib/components/FigureBlock.svelte';
    import PostNavTable from '$lib/components/PostNavTable.svelte';
    import SideNote from '$lib/components/SideNote.svelte';
    import { formatDate, toKebabCase } from '$lib/utils';

    import type { PageProps } from './$types';

    let { data }: PageProps = $props();
    let { metadata, blocks, prevPost, nextPost } = $derived(data);
</script>

<svelte:head>
    <title>{metadata.title} | {title}</title>
</svelte:head>

<div class="relative text-foreground min-h-screen">
    <main id="main" class="pt-16 pb-12 md:pt-40">
        <article class="container mx-auto max-w-3xl px-5 lg:px-20">
            <div class="mx-auto mb-16">
                <header class="relative">
                    <a
                        href={resolve('/posts')}
                        class="
                            group
                            hover:cursor-pointer
                            flex flex-col
                            text-left
                            mb-4
                        "
                    >
                        <span
                            class="font-monospace
                                text-muted-foreground
                                uppercase
                                tracking-[0.24em]
                                translate-x-0 translate-y-0
                                transition-transform duration-200
                                group-hover:translate-x-[-1em]
                                group-focus-visible:translate-x-[-1em]
                            "
                        >
                            &laquo; Posts
                        </span>
                    </a>

                    <!-- Post Title -->
                    <h1
                        class="relative mb-2 font-display text-3xl font-medium tracking-tight text-balance md:text-5xl lg:text-6xl"
                    >
                        {metadata.title}
                    </h1>

                    <dl
                        class="relative z-10 mb-2 flex flex-col gap-2 py-4 text-sm font-monospace uppercase tracking-wider"
                    >
                        <div
                            class="
                            grid grid-cols-[5.75rem_minmax(0,1fr)]
                            items-center gap-2"
                        >
                            <dt>published</dt>
                            <dd>
                                <time datetime={metadata.publish_date}
                                    >{formatDate(metadata.publish_date)}</time
                                >
                            </dd>
                        </div>
                        {#if metadata.edited_date}
                            <div
                                class="
                            grid grid-cols-[5.75rem_minmax(0,1fr)]
                            items-center gap-2"
                            >
                                <dt>edited</dt>
                                <dd>
                                    <time datetime={metadata.edited_date}
                                        >{formatDate(metadata.edited_date)}</time
                                    >
                                </dd>
                            </div>
                        {/if}
                    </dl>

                    {#if metadata.tags.length}
                        <div
                            class="relative z-10 flex gap-px text-md font-monospace text-faint-foreground"
                        >
                            <ul aria-label="Post tags" class="flex gap-4">
                                {#each metadata.tags as tag (tag)}
                                    <li class="flex gap-px">
                                        <span>{toKebabCase(tag)}</span>
                                    </li>
                                {/each}
                            </ul>
                        </div>
                    {/if}
                </header>
            </div>

            <!-- Post Content -->
            <div class="typst mx-auto text-muted-foreground leading-relaxed">
                <svelte:boundary onerror={(error) => console.error('post render failed', error)}>
                    {#each blocks as block, index (`${block.type}:${block.type === 'code' ? block.id : index}`)}
                        {#if block.type === 'html'}
                            {@html block.html}
                        {:else if block.type === 'side-note'}
                            <SideNote content={block.content} />
                        {:else if block.type === 'code'}
                            <CodeBlock
                                language={block.language}
                                source={block.source}
                                highlightedHtml={block.highlightedHtml}
                            />
                        {:else if block.type === 'figure'}
                            <FigureBlock
                                id={block.id}
                                content={block.content}
                                caption={block.caption}
                            />
                        {/if}
                    {/each}

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
    <div class="container mx-auto px-6 md:px-12 lg:px-20 max-w-6xl">
        <PostNavTable {prevPost} {nextPost} />
    </div>
</div>
