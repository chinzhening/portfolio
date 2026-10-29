<script lang="ts">
    import { resolve } from '$app/paths';
    import * as config from '$lib/config';
    import Seo from '$lib/components/Seo.svelte';
    import PostCard from '$lib/components/PostCard.svelte';

    import { padZero } from '$lib/utils';

    let { data } = $props();
</script>

<Seo title={config.title} path="/" />

<main id="main" class="page-prose">
    <div class="page-content">
        <!-- Main section / introduction -->
        <h1>1. Introduction</h1>
        <!-- greet -->
        <p>
            Hello there! I studied mathematics and statistics at NUS, and now I'm currently {config.status}
        </p>
        <p>
            I enjoy open source development and reading AI/ML research. Currently, I am working on
            the <a href="https://github.com/typst/typst">Typst project</a>, a modern typesetting
            system that I use to typeset technical documents.
        </p>

        <p>
            Check out my <a href={resolve('/resume.pdf')}>resume</a>
            and <a href="https://github.com/chinzhening">github</a>.
        </p>

        <!-- TODO: Add projects -->
        <!-- <section class="mt-8 md:mt-12 font-monospace">
        <div class="flex justify-between gap-4">
            <h2 class="flex items-center gap-4 text-sm tracking-wider font-semibold uppercase">
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
        <div class="flex justify-between items-center" style="margin-top: 2rem;">
            <h1 style="margin-top: 0rem;">2. posts</h1>
            <a
                class="
                text-nowrap
                text-border
                translate-x-0 translate-y-0
                transition-transform duration-200
                hover:translate-x-[1em]
                focus-visible:translate-x-[1em]"
                style="border: none;"
                href={resolve('/posts')}
            >
                all &raquo;
            </a>
        </div>
        <ul class="flex flex-col">
            {#each data.posts.slice(0, 3) as post, index (post.slug)}
                <li
                    class="
                grid py-4
                grid-cols-[16px_1fr] md:grid-cols-[24px_1fr]
                gap-3 md:gap-4
                not-first:border-t border-border
            "
                >
                    <div class="text-sm text-faint-foreground">
                        {padZero(index + 1)}.
                    </div>
                    <PostCard {post} />
                </li>
            {/each}
        </ul>

        <!-- Friend section -->
        <h1 class="section-heading">3. friends</h1>
        <p class="mt-2">
            Check out these cool and smart people:
            <a href="https://wyan.win/">Way Yan</a>,
            <a href="https://saddle196883.github.io/personalpage/aboutme/">Timo</a>
        </p>
    </div>
</main>
