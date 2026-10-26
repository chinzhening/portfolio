<script lang="ts">
    import { page } from '$app/state';
    import { pages } from '$lib/config';
    import { resolve } from '$app/paths';

    type Theme = 'system' | 'light' | 'dark';
    let theme = $state<Theme>(
        typeof localStorage !== 'undefined'
            ? (localStorage.getItem('theme') as Theme) || 'system'
            : 'system'
    );

    function toggleTheme() {
        const themes: Theme[] = ['system', 'light', 'dark'];
        theme = themes[(themes.indexOf(theme) + 1) % themes.length];

        if (theme === 'system') {
            document.documentElement.removeAttribute('color-scheme');
            localStorage.removeItem('theme');
        } else {
            document.documentElement.setAttribute('color-scheme', theme);
            localStorage.setItem('theme', theme);
        }
    }
</script>

<header
    class="
    container mx-auto
    max-w-3xl
    px-6
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

            <!-- Dark mode toggle -->
            <button
                class="theme-toggle"
                onclick={toggleTheme}
                aria-label="Dark mode toggle"
                aria-pressed={theme === 'dark'}
            ></button>
        </nav>
    </div>
    <!-- styled divider bottom -->
    <div
        class="bg-[linear-gradient(90deg,var(--accent-warm)_0_48px,var(--border)_48px)] h-px w-full"
    ></div>
</header>

<style>
    .active-link {
        color: var(--accent-warm);
        text-decoration: underline;
        text-underline-offset: 4px;
    }
    .hover-link {
        transition: color 0.1s ease;
    }
    .hover-link:hover,
    .hover-link:focus-visible {
        color: var(--accent-warm);
    }

    :global(:root[color-scheme='dark'] .theme-toggle:before) {
        transform: rotate(180deg);
    }

    .theme-toggle {
        cursor: pointer;
        background: 0 0;
        border: 0;
        place-items: center;
        width: 22px;
        height: 22px;
        margin: -4px -4px -2px 0;
        padding: 0;
        display: grid;
    }
    .theme-toggle:hover:before {
        border-color: var(--accent-warm);
        background-image: linear-gradient(90deg, var(--accent-warm) 50%, transparent 50%);
    }
    .theme-toggle:before {
        content: '';
        border: 1.5px solid var(--text-4);
        background: linear-gradient(90deg, var(--text-4) 50%, transparent 50%);
        border-radius: 50%;
        width: 12px;
        height: 12px;
        transition:
            transform 0.3s,
            border-color 0.15s,
            background-color 0.15s;
    }
</style>
