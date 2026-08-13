<script lang="ts">
    import * as config from '$lib/config';
</script>

<!-- Site footer: renders copyright and platform links. -->
<footer
    class="
    container mx-auto
    px-6 pb-8 pt-6 md:px-6 lg:px-20
    border-t border-border/50
    "
>
    <div class="flex flex-col gap-2">
        <p class="text-3xl text-muted-foreground" lang="zh">陈哲宁</p>
        <p class="font-monospace text-dim-foreground">portfolio@a57sdf ~/socials $ ls</p>
        <nav
            class="
            flex flex-col gap-1
            font-monospace
            text-dim-foreground
            lowercase tracking-widest
            text-xs"
        >
            {#each config.socials as social (social.name)}
                <a class="hover-link" rel="external" href={social.href}>{social.name}</a>
            {/each}
        </nav>
    </div>
    <p
        class="
        relative z-10
        mt-4
        font-monospace
        text-faint-foreground
        uppercase tracking-widest
        text-xs md:text-[0.72rem]"
    >
        <span class="block md:inline">Copyright &copy; {config.year}</span>
        <span class="hidden md:inline">·</span>
        <span class="block md:inline">
            Built with <a class="hover-link" href="https://svelte.dev">Svelte</a>
            <span>&</span>
            <a class="hover-link" href="https://typst.app">Typst</a>
        </span>
    </p>
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
