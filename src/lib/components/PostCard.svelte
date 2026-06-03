<script lang="ts">
    import HomeNoteCard from '$lib/components/HomeNoteCard.svelte';
    import TagChip from '$lib/components/TagChip.svelte';
    import { formatDate, padZero } from '$lib/utils';
    import type { PostSummary } from '$lib/posts';

    type PostCardData = PostSummary & {
        readingTime?: string;
        desc?: string | { text?: string };
    };

    let {
        post,
        index
    }: {
        post: PostCardData;
        index: number;
    } = $props();

    const descText = typeof post.desc === 'string' ? post.desc : (post.desc && typeof post.desc.text === 'string' ? post.desc.text : '');
</script>

<!-- Post preview card: date, title, summary, and up to three tags. -->
<a href={post.href} class="group block h-full transition-transform duration-200 hover:-translate-y-0.5">
    <HomeNoteCard eyebrow={post.readingTime} soft={index % 2 === 1}>
        <div class="flex h-full flex-col">
            <!-- Card header: publish date and open indicator. -->
            <div class="flex items-center justify-between gap-4">
                <span class="font-monospace text-xs uppercase tracking-[0.24em] text-muted-foreground">
                    {formatDate(post.publish_date)}
                </span>

                <span class="post-card__open mt-1 text-xs uppercase tracking-[0.18em] text-muted-foreground transition-transform duration-200 group-hover:translate-x-1 group-hover:translate-y-0.5">
                    <span class="post-card__open-number">{padZero(index + 1)}</span>
                    <span class="post-card__open-lines" aria-hidden="true">
                        <span></span>
                    </span>
                    <span>open</span>
                </span>
            </div>

            <!-- Card body: title and summary. -->
            <h2 class="mt-5 text-balance font-display text-3xl leading-tight font-medium text-foreground md:text-[2rem]">
                {post.title}
            </h2>

            <p class="mt-4 line-clamp-3 text-pretty text-base leading-8 text-muted-foreground md:text-lg">
                {post.desc.text}
            </p>

            <!-- Card footer: up to three preview tags. -->
            <div class="mt-auto pt-6">
                <div class="flex flex-wrap gap-3">
                    {#each post.tags.slice(0, 3) as tag, tagIndex (tag)}
                        <TagChip
                            text={tag}
                            className="post-card__stamp group-hover:-translate-x-0.5 group-hover:translate-y-1 transition-transform duration-200"
                            style={`transform: rotate(${tagIndex % 3 === 0 ? -2.5 : tagIndex % 3 === 1 ? 1.5 : -0.5}deg);`}
                        />
                    {/each}
                </div>
            </div>
        </div>
    </HomeNoteCard>
</a>

<style>
    .post-card__open {
        display: inline-flex;
        flex-direction: column;
        align-items: flex-end;
        gap: 0.35rem;
        text-align: right;
    }

    .post-card__open-number {
        font-family: var(--font-serif);
        font-size: 1.72rem;
        line-height: 1.25;
        letter-spacing: 0.15em;
        color: var(--text-2);
    }

    .post-card__open-lines {
        display: inline-flex;
        flex-direction: column;
        gap: 0.18rem;
        width: 2.9rem;
        align-items: flex-end;
    }

    .post-card__open-lines span {
        display: block;
        width: 100%;
        height: 0;
        border-top: 1px solid currentColor;
    }
</style>