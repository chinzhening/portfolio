<script>
	import PostCard from "$lib/components/PostCard.svelte";

    import { resolve }from '$app/paths';
    import { title } from '$lib/config';

    let { data } = $props();

    /* getPosts() returns newest-first, so the head of the list is the latest post. */
    const latestMonth = $derived(
        data.posts.length
            ? new Date(data.posts[0].publish_date).toLocaleDateString('en-US', {
                  month: 'short',
                  year: 'numeric'
              })
            : '—'
    );

</script>

<svelte:head>
    <title>All Posts | {title}</title>
</svelte:head>

<main class="bg-background mb-10">
    <div class="
        grid grid-rows-[auto_1fr] md:grid-cols-[minmax(0,0.4fr)_minmax(0,.62fr)]
        md:items-start
        mx-auto px-6 md:px-12 lg:px-20
        max-w-6xl
    ">
    <header class="
        py-16 md:py-32 md:pr-16
        md:mr-px
        md:sticky md:top-11
        w-full md:w-auto   
        z-5 bg-background
    ">
        <button
                type="button"
                onclick={() => window.location.assign(resolve('/'))}
                class="
                    group
                    hover:cursor-pointer
                    flex flex-col
                    text-left
                    mb-4
                ">
                <span
                    class="font-monospace
                        text-muted-foreground
                        uppercase
                        tracking-[0.24em]
                        translate-x-0 translate-y-0
                        transition-transform duration-200
                        group-hover:translate-x-[-1em]
                    "
                >
                    &laquo; home
                </span>
            </button>
        <!-- Main title with decorative elements -->
        <div class="relative">
            <h1
                class="
                    text-muted-foreground
                    text-5xl md:text-6xl lg:text-8xl
                    tracking-tight text-balance
                    font-display"
            >
                writing
            </h1>

            <div class="mt-4">
                <p class="text-muted-foreground tracking-[0.15em] text-pretty uppercase">
                    Thoughts, abstraction & meaning.
                </p>
            </div>
            <p class="font-serif text-dim-foreground mt-3">Essays, project write-ups, and high quality technical notes.</p>

            <!-- Metrics. Each pair is reversed so the value reads first while the
                 markup keeps the required <dt> before <dd> order. -->
            <dl class="mt-8 grid grid-cols-2 border-t border-border/50">
                <div class="pt-6 px-6 flex flex-col-reverse border-r border-border/50">
                    <dt class="mt-1 font-monospace text-xs uppercase tracking-widest text-faint-foreground">
                        entries
                    </dt>
                    <dd class="font-display text-3xl text-foreground">
                        {data.posts.length}
                    </dd>
                </div>

                <div class="pt-6 px-6 flex flex-col-reverse">
                    <dt class="mt-1 font-monospace text-xs uppercase tracking-widest text-faint-foreground">
                        latest month
                    </dt>
                    <dd class="font-display text-3xl text-foreground">
                        {latestMonth}
                    </dd>
                </div>
            </dl>
        </div>
    </header>
    <!-- Post List -->
    <section class="flex flex-col">
        {#each data.posts as post, i (i)}
            <PostCard {post} class="border-t md:border-t-0 md:not-first:border-t md:border-l border-border/50" />
        {/each}
        {#each data.posts as post, i (i)}
            <PostCard {post} class="border-t md:border-t-0 md:not-first:border-t md:border-l border-border/50" />
        {/each}
        <div class="min-h-10 border-l border-border/50"></div>
    </section>
    </div>
</main>
