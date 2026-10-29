<script lang="ts">
    import type { TypstComponentProps } from '$tyquire/svelte/types';

    let { props, children }: TypstComponentProps = $props();
    let label = $derived((props.label as string | undefined) ?? 'Note');
</script>

<aside class="callout" role="note" aria-label={label}>
    <div class="label" aria-hidden="true">{label}</div>
    {@render children()}
</aside>

<style>
    .callout {
        position: relative;
        margin: 2.5rem 0;
        padding: 3rem 1.5rem 1.5rem;
        border: 1px solid var(--border);
        background: var(--surface-2);
    }

    .label {
        position: absolute;
        top: 1.5rem;
        left: 1rem;
        z-index: 1;
        transform: translateY(-50%);
        padding: 0.35rem 0.6rem;
        color: var(--color-faint-foreground);
        font-family: var(--font-monospace);
        font-size: 0.8rem;
        line-height: 1;
        letter-spacing: 0.05rem;
        text-transform: uppercase;
    }

    .callout > :last-child {
        margin-bottom: 0;
    }

    @media (width < 40rem) {
        .callout {
            margin-inline: -1.5rem;
            width: calc(100% + 3rem);
            border-inline: 0;
        }
    }

    @media (width >= 64rem) {
        .callout {
            padding: 3rem 1.75rem 1.75rem;
        }
    }
</style>
