<script lang="ts">
    import { resolve } from '$app/paths';
    import { animate, fadeIn, fadeUp } from '$lib/animations';
    import { title } from '$lib/config';
</script>

<svelte:head>
    <title>Projects | {title}</title>
</svelte:head>

<main class="bg-background">
    <div class="mx-auto px-6 md:px-12 lg:px-20 max-w-3xl">
        <header class="py-16" use:animate={fadeUp}>
            <a class="group mb-4 flex flex-col text-left" href={resolve('/')}>
                <span class="
                    font-monospace
                    text-muted-foreground
                    uppercase
                    tracking-[0.24em]
                    transition-transform duration-200
                    group-hover:translate-x-[-1em]
                ">
                    &laquo; home
                </span>
            </a>

            <h1 class="
                text-5xl md:text-6xl lg:text-7xl
                tracking-tight text-balance
                font-display text-foreground"
            >
                projects
            </h1>

            <p class="mt-4 text-pretty text-muted-foreground">
                Things I have built, and the tools I reached for to build them.
            </p>
        </header>

        <!-- Project gallery. One card per project, stacked; dividers are on the
             list items so the rule spans the full column width. -->
        <ul class="flex flex-col pb-16">
            <li class="border-t border-border/50 py-8" use:animate={fadeIn('static')}>
                <h2 class="font-display text-xl md:text-2xl leading-tight text-foreground">
                    Squaredle Solver
                </h2>
                <p class="mt-2 text-pretty text-dim-foreground">
                    A script that plays the daily Squaredle puzzle on its own and files
                    every run into a database — half word-search solver, half plumbing.
                </p>
                <ul class="mt-4 flex flex-wrap gap-4 font-monospace text-xs text-faint-foreground">
                    <li>automation</li>
                    <li>python</li>
                    <li>database</li>
                </ul>
            </li>

            <li class="border-t border-border/50 py-8" use:animate={fadeIn('static')}>
                <h2 class="font-display text-xl md:text-2xl leading-tight text-foreground">
                    Block Blast Agent
                </h2>
                <p class="mt-2 text-pretty text-dim-foreground">
                    A reinforcement learning agent trained to play Block Blast, a puzzle
                    game by Hungry Studio.
                </p>
                <ul class="mt-4 flex flex-wrap gap-4 font-monospace text-xs text-faint-foreground">
                    <li>ai/ml</li>
                    <li>reinforcement learning</li>
                    <li>python</li>
                </ul>
            </li>

            <li class="border-t border-border/50 py-8" use:animate={fadeIn('static')}>
                <h2 class="font-display text-xl md:text-2xl leading-tight text-foreground">
                    Typst Blog Pipeline
                </h2>
                <p class="mt-2 text-pretty text-dim-foreground">
                    The compiler behind this site. Posts are authored in Typst and compiled
                    at build time into typed blocks that render as Svelte components.
                </p>
                <ul class="mt-4 flex flex-wrap gap-4 font-monospace text-xs text-faint-foreground">
                    <li>svelte</li>
                    <li>typescript</li>
                    <li>typst</li>
                </ul>
            </li>

            <li class="border-t border-border/50 py-8" use:animate={fadeIn('static')}>
                <h2 class="font-display text-xl md:text-2xl leading-tight text-foreground">
                    GitHub Metrics
                </h2>
                <p class="mt-2 text-pretty text-dim-foreground">
                    Pulling repository, commit, and contributor metrics out of the GitHub
                    API and visualising them.
                </p>
                <ul class="mt-4 flex flex-wrap gap-4 font-monospace text-xs text-faint-foreground">
                    <li>api</li>
                    <li>typescript</li>
                    <li>data-viz</li>
                </ul>
            </li>

            <li class="border-t border-border/50" aria-hidden="true"></li>
        </ul>
    </div>
</main>
