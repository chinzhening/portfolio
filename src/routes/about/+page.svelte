<script lang="ts">
    import { asset, resolve } from '$app/paths';
    import { animate, fadeIn, fadeUp } from '$lib/animations';
    import * as config from '$lib/config';
</script>

<svelte:head>
    <title>About | {config.title}</title>
</svelte:head>

<main id="main" class="bg-background">
    <div class="mx-auto px-6 md:px-12 lg:px-20 max-w-3xl">
        <header class="py-16" use:animate={fadeUp}>
            <a class="group mb-4 flex flex-col text-left" href={resolve('/')}>
                <span
                    class="
                    font-monospace
                    text-muted-foreground
                    uppercase
                    tracking-[0.24em]
                    transition-transform duration-200
                    group-hover:translate-x-[-1em]
                    group-focus-visible:translate-x-[-1em]
                "
                >
                    &laquo; home
                </span>
            </a>

            <h1
                class="
                text-5xl md:text-6xl lg:text-7xl
                tracking-tight text-balance
                font-display text-foreground"
            >
                about
            </h1>
            <div class="mt-6 flex gap-8 border-t border-border/50">
                <p
                    class="
                    group
                    px-4 py-8
                    text-muted-foreground font-monospace tracking-widest uppercase
                    border-r border-border/50"
                >
                    <a
                        class="
                        flex flex-col
                        items-center
                        translate-x-0 translate-y-0
                        transition-transform duration-200
                        group-hover:translate-y-[0.5em]
                        group-focus-within:translate-y-[0.5em]"
                        href={asset('/resume.pdf')}
                        download="resume.pdf"
                    >
                        <span>resume</span>
                        <span aria-hidden="true">&#x2B73;</span>
                    </a>
                </p>

                <nav
                    class="
                    mt-4
                    flex flex-col gap-1
                    font-monospace
                    text-dim-foreground
                    lowercase tracking-widest
                    "
                >
                    {#each config.socials as social (social.name)}
                        <a class="hover-link" href={social.href}>{social.name}</a>
                    {/each}
                </nav>
            </div>
        </header>

        <section class="flex flex-col pb-16 md:pb-24">
            <div class="py-8" use:animate={fadeIn('static')}>
                <h2 class="font-monospace text-sm uppercase tracking-widest text-faint-foreground">
                    background
                </h2>
                <p class="mt-4 text-pretty text-muted-foreground">
                    I grew up in New Zealand but have been based in Singapore since 2022. In 2026, I
                    graduated from the National University of Singapore with a B.Sc. in Mathematics.
                </p>
                <p class="mt-4 text-pretty text-muted-foreground">
                    University is where applied mathematics and software stopped being separate
                    subjects for me.
                </p>
                <p class="mt-4 text-pretty text-muted-foreground">...</p>
            </div>
            <div class="py-8" use:animate={fadeIn('static')}>
                <h2 class="font-monospace text-sm uppercase tracking-widest text-faint-foreground">
                    What I'm working on now
                </h2>
                <p class="mt-4 text-pretty text-muted-foreground">...</p>
            </div>
        </section>
    </div>
</main>

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
