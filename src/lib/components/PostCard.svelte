<script lang="ts">
    import { formatDate, toKebabCase } from '$lib/utils';
    import { animate, fadeIn } from '$lib/animations';

    import type { PostSummary } from '$lib/posts';

    let {
        post,
        class: className = ''
    }: {
        post: PostSummary;
        /* Positioning and dividers are the caller's business — see posts/+page.svelte. */
        class?: string;
    } = $props();

    const descText = $derived(typeof post.desc === 'string' ? post.desc : post.desc.text);
</script>

<!-- Post preview card: date, title, summary, and up to three tags. -->
<div class={['relative h-full py-4 px-4 md:px-8', className]}>
    <div class="flex h-full flex-col" use:animate={fadeIn('static')}>
        <!-- Card header: publish date and open indicator. -->
        <div class="flex justify-between pt-4">
            <!-- Tag list: up to three preview tags. -->
            <div>
                <div class="flex flex-wrap gap-4 text-xs font-monospace text-faint-foreground">
                    {#each post.tags.slice(0, 3) as tag (tag)}
                        <span>
                            {toKebabCase(tag)}
                        </span>
                    {/each}
                </div>
            </div>
            <span
                class="font-monospace text-[0.7rem] uppercase tracking-widest text-muted-foreground"
            >
                {formatDate(post.publish_date)}
            </span>
        </div>

        <!-- Card body: title and summary. -->
        <!-- Only the title is the link; ::after stretches its hit area over
             the whole card, so the accessible name stays just the title. -->
        <h2 class="mt-2 text-balance font-display leading-tight font-medium text-xl md:text-2xl">
            <!-- eslint-disable-next-line svelte/no-navigation-without-resolve -- already resolved, in posts.ts:20 -->
            <a class="after:absolute after:inset-0 after:content-['']" href={post.href}>
                {post.title}
            </a>
        </h2>

        <p class="mt-2 line-clamp-3 text-pretty text-dim-foreground">
            {descText}
        </p>
    </div>
</div>
