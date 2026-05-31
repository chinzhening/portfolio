<script lang="ts">
    import '$lib/css/article.css';
    import '$lib/css/shiki.css';

    import CodeBlock from '$lib/components/CodeBlock.svelte';
    import TagChip from '$lib/components/TagChip.svelte';
    import { formatDate } from '$lib/utils';

    let { data } = $props()
</script>

<div class="relative text-foreground min-h-screen">
    <main class="pt-36 pb-12">
        <article class="container mx-auto px-6 md:px-12 lg:px-20">
            <div class="mx-auto mb-16 max-w-4xl rounded-[2rem] border-1 border-border/15 bg-surface-1 shadow-[0_24px_80px_rgba(0,0,0,0.14)]">
                <header class="post-header-card relative overflow-hidden rounded-[2rem] px-6 py-6 md:px-8 md:py-8">
                    <!-- Background Letter -->
                    <span class="absolute -top-6 -left-4 select-none font-serif text-[8rem] leading-none font-light text-foreground/8 md:-left-6 md:-top-9 md:text-[12rem]">
                        {data.metadata.title.charAt(0).toUpperCase()}
                    </span>
                    <!-- Post Title -->
                    <h1 class="relative z-10 mb-5 font-display text-3xl font-medium tracking-tight text-balance md:text-5xl lg:text-6xl">
                        {data.metadata.title}
                    </h1>

                    <dl class="relative z-10 mb-6 flex flex-col gap-2 py-4 text-sm font-monospace uppercase tracking-[0.15em]">
                        <div class="grid grid-cols-[5.75rem_minmax(0,1fr)] items-center gap-2">
                            <dt class="text-muted-foreground">published</dt>
                            <dd>{formatDate(data.metadata.published)}</dd>
                        </div>
                        {#if data.metadata.updated}
                            <div class="grid grid-cols-[5.75rem_minmax(0,1fr)] items-center gap-2">
                                <dt class="text-muted-foreground">updated</dt>
                                <dd>{formatDate(data.metadata.updated)}</dd>
                            </div>
                        {/if}
                    </dl>

                    {#if data.metadata.tags.length}
                        <ul aria-label="Post tags" class="relative z-10 flex flex-wrap gap-3 text-md font-monospace uppercase tracking-[0.1em]">
                            {#each data.metadata.tags as tag (tag)}
                                <li>
                                    <TagChip text={tag} variant="stamp" />
                                </li>
                            {/each}
                        </ul>
                    {/if}
                </header>
            </div>

            <!-- Post Content -->
            <div class="typst mx-auto max-w-3xl text-muted-foreground leading-relaxed">
                {#each data.blocks as block, index (block.type === 'code' ? block.id : `${index}`)}
                    {#if block.type === 'html'}
                        {@html block.html}
                    {:else}
                        <CodeBlock language={block.language} source={block.source} highlightedHtml={block.highlightedHtml} />
                    {/if}
                {/each}
            </div>
        </article>
    </main>
</div>  

<style>
    .post-header-card {
        background:
            linear-gradient(180deg, color-mix(in oklab, var(--surface-1) 78%, transparent), transparent),
            repeating-linear-gradient(180deg, transparent 0, transparent 1.65rem, color-mix(in oklab, var(--border) 18%, transparent) 1.65rem, color-mix(in oklab, var(--border) 18%, transparent) 1.72rem);
    }
</style>