<script lang="ts">
    import PostCard from '$lib/components/PostCard.svelte';
    import SideFloat from '$lib/components/SideFloat.svelte';
    import Seo from '$lib/components/Seo.svelte';

    import { padZero } from '$lib/utils';
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

<Seo title="Posts" path="/posts" />

<main id="main" class="page-prose">
    <div class="page-content">
        <p class="mt-8 pt-8">Essays, project write-ups, and technical notes.</p>

        <h1>posts</h1>
        <section class="pb-20 relative">
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
                {#each data.posts as post, index (post.slug)}
                    <li
                        class="
                    grid py-4
                    grid-cols-[16px_1fr] md:grid-cols-[24px_1fr]
                    gap-3 md:gap-4
                    not-first:border-t border-border
                "
                    >
                        <div class="text-sm text-faint-foreground font-monospace">
                            {padZero(index + 1)}.
                        </div>
                        <PostCard {post} />
                    </li>
                {/each}
            </ul>
        </section>
    </div>
</main>
