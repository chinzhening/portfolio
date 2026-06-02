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
        rounded-[2rem]
        bg-[linear-gradient(180deg,color-mix(in_oklab,var(--surface-1)_78%,transparent),transparent),repeating-linear-gradient(180deg,transparent_0,transparent_1.65rem,color-mix(in_oklab,var(--border)_18%,transparent)_1.65rem,color-mix(in_oklab,var(--border)_18%,transparent)_1.72rem)]
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
                    border-b border-r border-border/30
                    px-[1.15rem] py-[1.1rem]
                    text-left text-text-1
                "
                onclick={() => navigateTo(prevPost.href)}
            >
                <span
                    class="font-monospace
                        text-text-2 text-[0.68rem]
                        uppercase
                        tracking-[0.24em]
                        translate-x-0 translate-y-0
                        transition-transform duration-200
                        group-hover:translate-x-[-0.15em]
                        group-hover:translate-y-[-0.15em]
                    "
                >
                    &laquo; previous post
                </span>
                <span
                    class="
                        font-display
                        text-[clamp(1.15rem,2.3vw,1.55rem)]
                        leading-[1.15]
                        [text-wrap:balance]
                        translate-y-0
                        transition-transform duration-200
                        group-hover:translate-y-[0.15em]
                    "
                >
                    <span>{prevPost.title}</span>
                </span>
            </button>
        {:else}
            <div
                class="
                    min-h-[7.25rem]
                    border-b
                    border-r
                    border-border/14
                    opacity-45
                "
            ></div>
        {/if}

        <div
            class="
                grid grid-cols-1 md:grid-cols-2
                min-h-[8rem] md:min-h-[7.25rem]
                items-stretch
                border-b
                border-r
                border-border/40
                divide-x
                divide-border/12
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
                    text-text-1

                    transition-transform duration-200
                    hover:translate-y-[-0.15em]
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
                    text-text-1

                    transition-transform duration-200
                    hover:translate-y-[-0.15em]
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
                    border-b
                    border-r
                    border-border/15
                    px-[1.15rem] py-[1.1rem]
                    text-right text-text-1
                "
                onclick={() => navigateTo(nextPost.href)}
            >
                <span
                    class="
                        font-monospace
                        text-[0.68rem]
                        uppercase
                        tracking-[0.24em]
                        text-text-2
                        translate-x-0 translate-y-0
                        transition-transform duration-200
                        group-hover:translate-x-[0.15em]
                        group-hover:translate-y-[-0.15em]
                    "
                >
                    next post &raquo;
                </span>
                <span
                    class="
                        font-display
                        text-[clamp(1.15rem,2.3vw,1.55rem)]
                        leading-[1.15]
                        [text-wrap:balance]
                        translate-y-0
                        transition-transform duration-200
                        group-hover:translate-y-[0.15em]
                    "
                >
                    <span>{nextPost.title}</span>
                </span>
            </button>
        {:else}
            <div
                class="
                    min-h-[7.25rem]
                    border-b
                    border-r
                    border-border/14
                    opacity-45
                "
                aria-hidden="true"
            ></div>
        {/if}
    </div>
</nav>

<style>
    .interactive {
        cursor: pointer;
        background-color: transparent;
        transition: all 0.2s;
        text-decoration: none;
    }

    .interactive:hover {
        background: color-mix(in oklab, var(--surface-3) 80%, transparent);
        color: color-mix(in oklab, var(--text-1) 70%, var(--brand) 30%);
    }
</style>
