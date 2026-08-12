<script lang="ts">
    import { pages } from '$lib/config';
    import { resolve } from '$app/paths';
</script>

<header
    class="
    sticky z-20 top-0
    bg-surface-1/80 backdrop-blur-[4px]
    border-b border-border/50
    shadow-md
    "
>
    <div
        class="
        container mx-auto
        px-6 md:px-6 lg:px-20
        flex gap-4 justify-between
    "
    >
        <a class="text-lg py-2" href={resolve('/')} aria-label="Home"><span lang="zh">哲宁</span></a
        >
        <nav class="items-center flex font-monospace lowercase text-dim-foreground">
            {#each pages as page (page.name)}
                <a
                    class="
                hover-link
                py-3 px-4
                justify-self-center
                border-l border-border/50
                text-sm
                uppercase tracking-widest
                "
                    href={page.href}>{page.name}</a
                >
            {/each}
        </nav>
    </div>
</header>

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
