<script lang="ts">
    import { animate, fadeUp } from '$lib/animations';

    let {
        eyebrow,
        soft = false,
        children
    } = $props<{
        eyebrow: string;
        soft?: boolean;
        children: import('svelte').Snippet;
    }>();
</script>

<div class:home-postcard__note--soft={soft} class="home-postcard__note" use:animate={fadeUp}>
    <h3 class="font-monospace text-xs uppercase tracking-[0.3em] text-muted-foreground">{eyebrow}</h3>
    <div class="mt-4 text-pretty leading-8 text-muted-foreground md:text-lg">
        {@render children()}
    </div>
</div>

<style>
    .home-postcard__note {
        min-height: 100%;
        border-radius: 1.5rem;
        border: 1px solid color-mix(in oklab, var(--border) 40%, transparent);
        background: var(--surface-1);
        padding: 1.5rem;
        box-shadow: 0 16px 40px rgba(0, 0, 0, 0.08);
    }

    .home-postcard__note--soft {
        background: color-mix(in oklab, var(--surface-2) 74%, var(--surface-1) 26%);
    }

    @media (min-width: 768px) {
        .home-postcard__note {
            padding: 2rem;
        }
    }
</style>