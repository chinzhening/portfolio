<script lang="ts">
    import { resolve } from '$app/paths';
    import * as config from '$lib/config';
    import PostCard from '$lib/components/PostCard.svelte';

    import { padZero } from '$lib/utils';

    let { data } = $props();
</script>

<svelte:head>
    <title>{config.title}</title>
</svelte:head>

<main id="main" class="min-h-screen bg-background">
    <div class="mx-auto pb-20 px-6 max-w-3xl">
        <!-- Main section / introduction -->
        <section class="mt-8 md:mt-12 text-md font-monospace">
            <!-- greet -->
            <p class="mt-4 text-faint-foreground">```</p>
            <p>
                Hello there! I studied mathematics and statistics at NUS, and now I'm currently {config.status}
            </p>
            <p class="mt-4">
                I enjoy open source development and reading AI/ML research. Currently, I am working
                on the <a class="external-link" href="https://github.com/typst/typst"
                    >Typst project</a
                >, a modern typesetting system that I use to typeset technical documents.
            </p>

            <p class="mt-4">
                Check out my <a
                    class="text-accent-warm underline underline-offset-2"
                    href={resolve('/resume.pdf')}>resume</a
                >
                and <a class="external-link" href="https://github.com/chinzhening">github</a>.
            </p>
            <p class="mt-2 text-faint-foreground">```</p>
        </section>

        <!-- TODO: Add projects -->
        <!-- <section class="mt-8 md:mt-12 font-monospace">
            <div class="flex justify-between gap-4">
                <h2 class="flex items-center gap-4 text-sm text-accent tracking-wider font-semibold uppercase">
                    = projects
                </h2>

                <a
                    class="
                        text-nowrap
                        text-border
                        translate-x-0 translate-y-0
                        transition-transform duration-200
                        hover:translate-x-[1em]
                        focus-visible:translate-x-[1em]"
                    href={resolve('/projects')}
                >
                    all projects &raquo;
                </a>
            </div>
        </section> -->

        <!-- Recent posts -->
        <section class="mt-8 md:mt-12 font-monospace">
            <div class="flex justify-between gap-4">
                <h2
                    class="flex items-center gap-4 text-sm text-accent-warm tracking-wider font-semibold uppercase"
                >
                    = recent posts
                </h2>

                <a
                    class="
                        text-nowrap
                        text-border
                        translate-x-0 translate-y-0
                        transition-transform duration-200
                        hover:translate-x-[1em]
                        focus-visible:translate-x-[1em]"
                    href={resolve('/posts')}
                >
                    all posts &raquo;
                </a>
            </div>

            <ul class="flex flex-col">
                {#each data.posts.slice(0, 3) as post (post.slug)}
                    <li
                        class="
                        grid py-4 pl-2
                        grid-cols-[32px_1fr] md:grid-cols-[44px_1fr]
                        gap-2 md:gap-3
                        not-first:border-t border-border/50
                    "
                    >
                        <div class="pt-1 text-sm text-faint-foreground">
                            {padZero(data.posts.indexOf(post) + 1)}.
                        </div>
                        <PostCard {post} />
                    </li>
                {/each}
            </ul>
        </section>

        <!-- Friend section -->
        <section class="mt-8 md:mt-12 font-monospace">
            <h2
                class="flex items-center gap-4 text-sm text-accent-warm tracking-wider font-semibold uppercase"
            >
                = friends
            </h2>
            <p class="mt-2">
                Check out these cool and smart people:
                <a class="external-link" href="https://wyan.win/">Way Yan</a>,
                <a class="external-link" href="https://saddle196883.github.io/personalpage/aboutme/"
                    >Timo</a
                >
            </p>
        </section>
    </div>
</main>

<style>
    .external-link {
        color: var(--accent-warm);
        text-decoration: underline;
        text-underline-offset: 2px;
    }
</style>
