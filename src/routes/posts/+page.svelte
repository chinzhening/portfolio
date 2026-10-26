<script lang="ts">
    import PostCard from '$lib/components/PostCard.svelte';
    import SideFloat from '$lib/components/SideFloat.svelte';

    import { padZero } from '$lib/utils';
    import { title } from '$lib/config';
    import type { PageProps } from './$types';

    let { data }: PageProps = $props();

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
    <title>Posts | {title}</title>
</svelte:head>

<main id="main" class="bg-background w-full mx-auto max-w-3xl px-6">
    <header
        class="
        mt-8 md:mt-12
        font-monospace
    "
    >
        <div class="relative font-monospace">
            <p class="mt-4 text-faint-foreground">```</p>
            <p>Essays, project write-ups, and technical notes.</p>
            <p class="mt-2 text-faint-foreground">```</p>
        </div>
    </header>

    <section class="mt-2 pb-20 relative">
        <SideFloat class="font-monospace">
            <!-- Metrics. Each pair is reversed so the value reads first while the
            markup keeps the required <dt> before <dd> order. -->
            <div class="pl-3 py-6 xl:py-0">
                <dl class="grid grid-cols-[60px_1fr] gap-4 pb-2">
                    <div class="flex flex-col-reverse">
                        <dt
                            class="pb-2 mt-1 text-xs uppercase tracking-widest text-faint-foreground"
                        >
                            entries
                        </dt>
                        <dd class="text-xl text-foreground">
                            {data.posts.length}
                        </dd>
                    </div>

                    <div class="flex flex-col-reverse">
                        <dt
                            class="pb-2 mt-1 text-xs uppercase tracking-widest text-faint-foreground"
                        >
                            latest month
                        </dt>
                        <dd class="text-xl text-foreground">
                            {latestMonth}
                        </dd>
                    </div>
                </dl>
            </div>
        </SideFloat>

        <!-- Post list -->
        <ul class="flex flex-col">
            {#each data.posts as post (post.slug)}
                <li
                    class="
                    grid py-4 pl-2
                    grid-cols-[32px_1fr] md:grid-cols-[44px_1fr]
                    gap-2 md:gap-3
                    not-first:border-t border-border/50
                "
                >
                    <div class="pt-1 text-sm text-faint-foreground font-monospace">
                        {padZero(data.posts.indexOf(post) + 1)}.
                    </div>
                    <PostCard class="" {post} />
                </li>
            {/each}
        </ul>
    </section>
</main>
