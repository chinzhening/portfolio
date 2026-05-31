<script lang="ts">
    import type { Snippet } from 'svelte';

    type TagChipVariant = 'stamp' | 'inline' | 'postcard';

    let {
        text = '',
        variant = 'stamp',
        className = '',
        style = '',
        href,
        download,
        target,
        rel,
        children
    }: {
        text?: string;
        variant?: TagChipVariant;
        className?: string;
        style?: string;
        href?: string;
        download?: boolean | string;
        target?: string;
        rel?: string;
        children?: Snippet;
    } = $props();

</script>

<svelte:element
    this={href ? 'a' : 'span'}
    href={href}
    download={href ? download : undefined}
    target={target}
    rel={rel}
    class={`tag-chip tag-chip--${variant} ${className}`.trim()}
    style={style}>
    {#if children}
        {@render children()}
    {:else}
        {text}
    {/if}
</svelte:element>

<style>
    .tag-chip {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        text-transform: uppercase;
        font-family: var(--font-monospace);
        line-height: 1;
        text-decoration: none;
    }

    a.tag-chip {
        transition: color 150ms ease, border-color 150ms ease, background-color 150ms ease;
    }

    a.tag-chip:hover,
    a.tag-chip:focus-visible {
        color: color-mix(in oklab, var(--text-1) 82%, var(--brand) 18%);
        border-color: color-mix(in oklab, var(--brand) 38%, transparent);
    }

    .tag-chip--stamp {
        min-height: 2rem;
        padding: 0.4rem 0.8rem;
        border: 1px dashed color-mix(in oklab, var(--border) 78%, transparent);
        border-radius: 0.35rem;
        background: color-mix(in oklab, var(--surface-2) 82%, var(--surface-1) 18%);
        box-shadow:
            inset 0 0 0 1px color-mix(in oklab, var(--text-1) 6%, transparent),
            0 8px 18px rgba(0, 0, 0, 0.05);
        color: var(--text-2);
        font-size: 0.68rem;
        letter-spacing: 0.18em;
    }

    .tag-chip--inline {
        border-bottom: 1px solid color-mix(in oklab, var(--border) 66%, transparent);
        padding: 0 0.25rem 0.25rem;
        color: var(--text-1);
        font-size: 0.68rem;
        letter-spacing: 0.1em;
    }

    .tag-chip--postcard {
        width: 6.25rem;
        height: 6.5rem;
        border: 1px dashed color-mix(in oklab, var(--text-1) 30%, transparent);
        border-radius: 0.9rem;
        padding: 0.5rem;
        flex-direction: column;
        justify-content: center;
        gap: 0.35rem;
        align-items: center;
        font-size: 0.8rem;
        letter-spacing: 0.2em;
        color: var(--text-2);
        background: color-mix(in oklab, var(--surface-2) 75%, transparent);
        box-shadow: inset 0 0 0 1px color-mix(in oklab, var(--border) 35%, transparent);
    }
</style>
