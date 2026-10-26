<script lang="ts">
    import { page } from '$app/state';
    import { pages } from '$lib/config';
    import { resolve } from '$app/paths';
</script>

<header
    class="
    container mx-auto
    max-w-3xl
    px-6
    bg-surface-1/80
    "
>
    <div class="flex gap-4 justify-between">
        <a class="font-monospace text-md pt-2 pb-1" href={resolve('/')} aria-label="Home"
            ><span>zhening:blog</span></a
        >
        <nav class="items-center flex font-monospace lowercase text-dim-foreground">
            <!-- Block form, not disable-next-line: the href sits mid-tag and the
                 directive can only target the line after it. -->
            <!-- eslint-disable svelte/no-navigation-without-resolve -- already resolved, in config.ts:8-10 -->
            {#each pages as navPage (navPage.name)}
                <a
                    class="
                        {page.url.pathname === navPage.href ? 'active-link' : 'hover-link'}
                        py-1 px-2
                        justify-self-center
                        text-xs
                        uppercase tracking-widest
                        "
                    href={navPage.href}
                    aria-current={page.url.pathname === navPage.href ? 'page' : undefined}
                    >{navPage.name}</a
                >
            {/each}
            <!-- eslint-enable svelte/no-navigation-without-resolve -->
        </nav>
    </div>
    <!-- styled divider bottom -->
    <div
        class="bg-[linear-gradient(90deg,var(--brand)_0_48px,var(--border)_48px)] h-px w-full"
    ></div>
</header>

<style>
    .active-link {
        color: var(--brand);
        text-decoration: underline;
        text-underline-offset: 4px;
    }
    .hover-link {
        transition: color 0.1s ease;
    }
    .hover-link:hover,
    .hover-link:focus-visible {
        color: var(--brand);
    }
</style>
