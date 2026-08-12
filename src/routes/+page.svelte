<script lang="ts">
    import { resolve } from '$app/paths';
    import * as config from '$lib/config';
    import { animate, fadeIn, fadeUp } from '$lib/animations';
    import PostCard from '$lib/components/PostCard.svelte';
    import Typing from '$lib/components/Typing.svelte';

    let { data } = $props();

    const roles = ['creator.', 'developer.', 'ai enthusiast.', 'coffee lover.'];
</script>

<svelte:head>
    <title>{config.title}</title>
</svelte:head>

<main class="min-h-screen bg-background">
    <div
        class="
        grid
        md:grid-cols-[minmax(0,0.4fr)_minmax(0,.62fr)]
        md:items-start
        mx-auto px-6 md:px-12 lg:px-20
        max-w-6xl
        border-b border-border/50
    "
    >
        <header class="py-16 md:py-24 md:pr-16 v-full" use:animate={fadeUp}>
            <h1
                class="
                text-5xl md:text-6xl lg:text-7xl
                tracking-tight text-balance
                font-display text-foreground
            "
            >
                {config.name}
            </h1>

            <p class="mt-4 font-monospace uppercase tracking-widest text-muted-foreground">
                i'm a
                <span class="text-brand"
                    ><Typing words={roles} typeSpeed={200} cursor="block" /></span
                >
            </p>

            <p class="mt-3 font-serif text-dim-foreground">{config.status}</p>
        </header>

        <section class="flex flex-col md:pt-24">
            <div
                class="
                border-t md:border-t-0 md:not-first:border-t
                md:border-l
                border-border/50
                py-6 md:py-8 md:px-8
                "
                use:animate={fadeIn('static')}
            >
                <h2 class="font-monospace text-sm uppercase tracking-widest text-faint-foreground">
                    about
                </h2>
                <p class="mt-4 text-pretty text-muted-foreground">
                    I grew up in New Zealand but have been based in Singapore since 2022. In 2026, I
                    graduated from the National University of Singapore with a B.Sc. in Mathematics.
                </p>
                <p class="mt-4 text-pretty text-muted-foreground">
                    I work in applied mathematics and software development.
                </p>
            </div>

            <div
                class="
                border-t md:border-t-0 md:not-first:border-t
                md:border-l
                border-border/50
                py-6 md:py-8 md:px-8
                "
                use:animate={fadeIn('static')}
            >
                <h2 class="font-monospace text-sm uppercase tracking-widest text-faint-foreground">
                    this blog
                </h2>
                <p class="mt-4 text-pretty text-muted-foreground">
                    Where the experiments and notes end up. Posts are written in Typst and compiled
                    to HTML at build time, so the mathematics is typeset rather than approximated.
                </p>
            </div>
        </section>
    </div>

    <div class="px-6">
        <section class="py-10 md:py-16 mx-auto max-w-200" use:animate={fadeUp}>
            <div class="flex justify-between font-monospace text-sm uppercase tracking-widest">
                <h2 class="text-faint-foreground">recent writing</h2>

                <a
                    class="
                        text-muted-foreground hover:text-brand focus-visible:text-brand
                        translate-x-0 translate-y-0
                        transition-transform duration-200
                        hover:translate-x-[1em]
                        focus-visible:translate-x-[1em]"
                    href={resolve('/posts')}
                >
                    all posts &raquo;
                </a>
            </div>

            <ul class="mt-4 flex flex-col">
                {#each data.posts.slice(0, 3) as post (post.slug)}
                    <li class="not-first:border-t border-border/50">
                        <PostCard {post} class="py-2 md:py-4 md:px-4" />
                    </li>
                {/each}
            </ul>
        </section>
    </div>
</main>
