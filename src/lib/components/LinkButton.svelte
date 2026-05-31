<script lang="ts">
    import type { Snippet } from 'svelte';

    type LinkButtonVariant = 'primary' | 'ghost' | 'back';

    let {
        href,
        variant = 'primary',
        className = '',
        target,
        rel,
        children
    }: {
        href: string;
        variant?: LinkButtonVariant;
        className?: string;
        target?: string;
        rel?: string;
        children?: Snippet;
    } = $props();
</script>

<a href={href} target={target} rel={rel} class={`link-button link-button--${variant} ${className}`.trim()}>
    {@render children?.()}
</a>

<style>
    .link-button {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.65rem;
        min-height: 2.9rem;
        padding: 0.75rem 1.1rem;
        border-radius: 9999px;
        border: 1px solid color-mix(in oklab, var(--text-1) 18%, transparent);
        color: var(--text-1);
        font-family: var(--font-monospace);
        font-size: 0.78rem;
        letter-spacing: 0.18em;
        text-transform: uppercase;
        text-decoration: none;
        transition: border-color 160ms ease, background-color 160ms ease, color 160ms ease, box-shadow 160ms ease;
    }

    .link-button:hover,
    .link-button:focus-visible {
        border-color: color-mix(in oklab, var(--brand) 40%, transparent);
        background: color-mix(in oklab, var(--surface-2) 90%, var(--brand) 10%);
        color: color-mix(in oklab, var(--text-1) 84%, var(--brand) 16%);
        box-shadow: 0 2px 10px color-mix(in oklab, var(--brand) 16%, transparent);
    }

    .link-button--primary {
        background: var(--surface-2);
    }

    .link-button--ghost {
        background: transparent;
    }

    .link-button--back {
        min-height: auto;
        padding: 0.55rem 0.95rem;
        background: color-mix(in oklab, var(--surface-2) 78%, var(--surface-1) 22%);
        color: var(--text-2);
        font-size: 0.72rem;
        box-shadow: inset 0 0 0 1px color-mix(in oklab, var(--text-1) 5%, transparent);
    }

    @media (prefers-reduced-motion: reduce) {
        .link-button {
            transition: none;
        }
    }
</style>
