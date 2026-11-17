<script lang="ts">
    import { formatDate } from '#lib/utils.ts';
    import SideFloat from '#lib/components/SideFloat.svelte';
    import Seo from '#lib/components/Seo.svelte';
    import type { PageProps } from './$types';

    let { data }: PageProps = $props();

    const latestMonth = $derived(
        data.posts.length
            ? new Date(data.posts[0].publish_date).toLocaleDateString('en-US', {
                  month: 'short',
                  year: 'numeric'
              })
            : '—'
    );
</script>

<Seo title="Posts" />

<main id="main" class="posts-page">
    <section class="posts-content">
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
        <header class="posts-header">
            <h1>Posts</h1>
            <p>Notes on software, tools, and technical writing.</p>
        </header>
        <table class="post-table">
            <tbody>
                {#each data.posts as post (post.slug)}
                    <tr>
                        <td
                            ><time datetime={post.publish_date}
                                >{formatDate(post.publish_date)}</time
                            ></td
                        >
                        <td>
                            <a href={post.href}>{post.title}</a>
                        </td>
                    </tr>
                {/each}
            </tbody>
        </table>
    </section>
</main>

<style>
    .posts-page {
        min-height: 100vh;
        background: var(--background);
    }

    .posts-content {
        max-width: 80ch;
        margin-inline: auto;
        padding: 2rem 1.5rem 5rem;
    }

    .posts-header {
        padding-bottom: 1.5rem;
        font-family: var(--font-monospace);
    }

    h1 {
        color: var(--text-1);
        font-size: 0.875rem;
        font-weight: 700;
        letter-spacing: 0.08em;
        line-height: 1.25;
        text-transform: uppercase;
    }

    .posts-header p {
        margin-top: 0.75rem;
        color: var(--text-2);
    }

    .post-table {
        width: 100%;
        margin-top: 1.5rem;
        border-collapse: collapse;
        font-family: var(--font-monospace);
    }

    .post-table td {
        padding: 0.75rem 0;
        text-align: left;
    }

    .post-table td:first-child {
        width: 7rem;
        color: var(--text-2);
        font-size: 0.75rem;
    }
</style>
