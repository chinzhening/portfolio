<script lang="ts">
    import * as config from '$lib/config';
</script>

<!-- Site footer: renders copyright and platform links. -->
<footer class="footer-blend px-6 py-8 text-center text-muted-foreground/55 md:px-12 lg:px-20">
    <p class="relative z-10 font-monospace text-[0.68rem] uppercase tracking-[0.22em] md:text-[0.72rem]">
        <span class="block md:inline">Copyright &copy; {config.year} {config.name}</span>
        <span class="mx-2 hidden md:inline">·</span>
        <span class="block md:inline">
            Powered by <a class="transition-colors hover:text-muted-foreground hover:underline underline-offset-4" href="https://svelte.dev">Svelte</a>
            <span class="mx-1">and</span>
            <a class="transition-colors hover:text-muted-foreground hover:underline underline-offset-4" href="https://typst.app">Typst</a>
        </span>
    </p>
</footer>

<style>
    .footer-blend {
        position: relative;
        overflow: clip;
        background: linear-gradient(180deg, transparent 0%, color-mix(in oklab, var(--surface-1) 92%, var(--background) 8%) 100%);
    }

    .footer-blend::after {
        content: '';
        position: absolute;
        inset: auto 0 0 auto;
        width: min(22rem, 58vw);
        height: 5rem;
        background: radial-gradient(
            circle at bottom right,
            color-mix(in oklab, var(--background) 42%, transparent) 0%,
            color-mix(in oklab, var(--surface-1) 20%, transparent) 42%,
            transparent 78%
        );
        pointer-events: none;
    }
</style>