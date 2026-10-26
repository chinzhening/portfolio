<script lang="ts">
    import * as config from '$lib/config';
</script>

<!-- Site footer: renders copyright and platform links. -->
<footer
    class="
    container mx-auto
    px-6 pb-8 pt-6
    max-w-3xl
    border-t border-border/50
    "
>
    <div class="flex-col md:flex justify-between font-monospace">
        <span class="text-xs text-faint-foreground uppercase tracking-widest"
            >{config.name} &copy; {config.year}</span
        >
        <nav
            class="
            flex gap-3
            uppercase
            text-brand
            tracking-widest
            text-xs"
        >
            {#each config.socials as social (social.name)}
                <a class="hover-link" rel="external" href={social.href}>{social.name}</a>
            {/each}

            <span class="text-faint-foreground">---+></span>

            <p
                class="
                relative
                font-monospace
                text-faint-foreground
                uppercase tracking-widest
                text-xs md:text-[0.72rem]"
            >
                <span class="block md:inline">
                    <a class="hover-link" href="https://svelte.dev">Svelte</a>
                    <span>\</span>
                    <a class="hover-link" href="https://typst.app">Typst</a>
                </span>
            </p>
        </nav>
    </div>
</footer>

<style>
    .hover-link {
        transition: color 0.2s ease;
    }
    .hover-link:hover,
    .hover-link:focus-visible {
        color: var(--brand);
        text-underline-offset: 4px;
    }
</style>
