<script lang="ts">
    import type { PostSummary } from '$lib/posts';

    let { prevPost = null, nextPost = null }: { prevPost?: PostSummary | null; nextPost?: PostSummary | null } = $props();

    function navigateTo(path: string) {
        window.location.assign(path);
    }

    function scrollToTop() {
        window.scrollTo({ top: 0, left: 0, behavior: 'smooth' });
    }
</script>

<nav
    class="
        mt-12
        overflow-hidden
        border-t border-border/30
    "
    aria-label="Post navigation"
>
    <div
        class="
            grid
            gap-0
            md:grid-cols-[minmax(0,1fr)_minmax(14rem,16rem)_minmax(0,1fr)]
            md:items-stretch
        "
    >
        {#if prevPost}
            <button
                type="button"
                class="
                    group interactive
                    min-h-[7.25rem] w-full
                    flex flex-col justify-center gap-[0.65rem]
                    px-[1.15rem] py-[1.1rem]
                    text-left text-foreground
                "
                onclick={() => navigateTo(prevPost.href)}
            >
                <span
                    class="font-monospace
                        text-muted-foreground text-[0.68rem]
                        uppercase
                        tracking-[0.24em]
                        translate-x-0 translate-y-0
                        transition-transform duration-200
                        group-hover:translate-x-[-1em]
                    "
                >
                    &laquo; previous post
                </span>
                <span
                    class="
                        font-display
                        text-[clamp(1.15rem,2.3vw,1.55rem)]
                        leading-[1.15]
                        text-balance
                        translate-y-0
                    "
                >
                    <span>{prevPost.title}</span>
                </span>
            </button>
        {:else}
            <div class="min-h-[7.25rem] opacity-45" aria-hidden="true"></div>
        {/if}

        <div
            class="
                grid grid-cols-1 md:grid-cols-2
                min-h-[8rem] md:min-h-[7.25rem]
                items-stretch
                md:border-r
                md:border-l
                border-border/50
            "
        >
            <button
                type="button"
                class="
                    interactive
                    inline-flex
                    min-h-full
                    w-full
                    items-center
                    justify-center
                    font-monospace
                    uppercase
                    tracking-[0.18em]
                    text-foreground

                    border-b md:border-b-0
                    md:border-r
                    border-border/50


                    transition-transform duration-200
                    hover:translate-y-[-0.5em]
                "
                onclick={scrollToTop}
            >
                top
            </button>
            <button
                type="button"
                class="
                    interactive
                    inline-flex
                    min-h-full
                    w-full
                    items-center
                    justify-center
                    bg-transparent
                    font-monospace
                    uppercase
                    tracking-[0.18em]
                    text-foreground

                    transition-transform duration-200
                "
                onclick={() => navigateTo('/posts')}
            >
                posts
            </button>
        </div>

        {#if nextPost}
            <button
                type="button"
                class="
                    group interactive
                    flex
                    min-h-[7.25rem]
                    w-full
                    flex-col
                    justify-center
                    gap-[0.65rem]
                    px-[1.15rem] py-[1.1rem]
                    text-right text-foreground
                "
                onclick={() => navigateTo(nextPost.href)}
            >
                <span
                    class="
                        font-monospace
                        text-[0.68rem]
                        uppercase
                        tracking-[0.24em]
                        text-muted-foreground
                        translate-x-0 translate-y-0
                        transition-transform duration-200
                        group-hover:translate-x-[1em]
                    "
                >
                    next post &raquo;
                </span>
                <span
                    class="
                        font-display
                        text-[clamp(1.15rem,2.3vw,1.55rem)]
                        leading-[1.15]
                        text-balance
                        translate-y-0
                    "
                >
                    <span>{nextPost.title}</span>
                </span>
            </button>
        {:else}
            <div class="min-h-[7.25rem]" aria-hidden="true"></div>
        {/if}
    </div>
</nav>

<style>
    .interactive {
        /* Tailwind v4 writes movement to `translate`, not `transform`. This
           scoped rule is unlayered and beats `transition-transform`, so it has
           to name `translate` itself or the hover lift snaps. */
        transition: color 0.2s ease, translate 0.2s ease;
    }
    .interactive:hover {
        color: var(--brand);
    }
</style>