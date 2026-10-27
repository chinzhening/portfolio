<script lang="ts">
    import { getTagHref } from '$lib/posts';

    import type { TagSummary } from '$lib/posts';

    let {
        tag,
        active = false
    }: {
        tag: TagSummary;
        active?: boolean;
    } = $props();
</script>

<!-- eslint-disable svelte/no-navigation-without-resolve -- getTagHref returns a resolved URL -->
<a
    class="tag-link"
    class:active
    href={getTagHref(tag.slug)}
    aria-current={active ? 'page' : undefined}
>
    {tag.label}
    <span class="text-faint-foreground">({tag.count})</span>
</a>

<!-- eslint-enable svelte/no-navigation-without-resolve -->

<style>
    .tag-link {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        border: 1px solid var(--accent-cool);
        padding: 0.25rem 0.5rem;
        color: var(--accent-cool);
        font-size: 0.75rem;
    }

    .tag-link:hover,
    .tag-link:focus-visible,
    .tag-link.active {
        border-color: var(--accent-warm);
        color: var(--accent-warm);
    }

    .tag-link.active {
        background-color: var(--surface-2);
    }
</style>
