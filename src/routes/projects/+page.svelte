<script lang="ts">
    import Seo from '$lib/components/Seo.svelte';
</script>

<Seo title="Projects" path="/projects" />

<main id="main" class="bg-background">
    <div class="mx-auto px-6 max-w-3xl mb-20 font-monospace">
        <header class="py-8">
            <p class="mt-4">```</p>
            <p class="text-muted-foreground">
                A curation of personal projects and documented open-source contributions.
            </p>
            <p class="mt-4 text-muted-foreground">
                Warning: this is still a massive work-in-progress.
            </p>
            <p class="mt-4 text-muted-foreground">Typst</p>
            <p class="text-muted-foreground">
                - <a
                    class="external-link"
                    href="https://github.com/typst/typst/pull/9016"
                    target="_blank"
                    rel="noopener noreferrer">PR #9016 (10-26-2026)</a
                >
                : Fix invalid SVG output with text content in tiling
            </p>
            <p class="text-muted-foreground">
                - <a
                    class="external-link"
                    href="https://github.com/typst/typst/pull/8992"
                    target="_blank"
                    rel="noopener noreferrer">PR #8992 (10-23-2026)</a
                >
                : Fix spread argument override in typed HTML constructor
            </p>
            <p class="text-muted-foreground">
                - <a
                    class="external-link"
                    href="https://github.com/typst/typst/pull/8963"
                    target="_blank"
                    rel="noopener noreferrer">PR #8963 (10-16-2026)</a
                >
                : Remove tracking from the last glyph in a line
            </p>
            <p class="mt-2">```</p>
        </header>

        <!-- Project gallery. One card per project, stacked; dividers are on the
             list items so the rule spans the full column width. -->
        <ul class="flex flex-col pb-16">
            <li class="py-8">
                <h2 class="section-heading">= Squaredle Solver</h2>
                <p class="mt-2 text-pretty text-dim-foreground">
                    A program that plays the popular daily <a
                        class="external-link"
                        href="https://squaredle.app"
                        target="_blank"
                        rel="noopener noreferrer">Squaredle</a
                    > puzzle on its own and files every run into a database. The Python script shells
                    out to a solver written in C++ that uses a trie-routed backtracking algorithm to find
                    every word that satisfies the constraints. This was a fun exercise that challegend
                    me to learn benchmarking practices, optimization techniques, and data plumbing. From
                    the first pointer-based trie implementation, I improved the solver to use a serializable,
                    compact, sparse flat trie that reduced the runtime from ~150ms to ~4ms per puzzle
                    on my machine.
                </p>
                <p class="mt-4 text-pretty text-dim-foreground">
                    I tested several approaches to squeeze the most performance out of my solver,
                    before settling on the sparse flat trie, with an implementation (serialization
                    format) that uses bitset operations to check for child nodes. Writing a blog
                    post for this has been on the backburner for a while, but I plan to write one
                    soon to share my learnings. These are the kinds of things you don't normally
                    learn in a typical DSA course.
                </p>
                <ul class="mt-4 flex flex-wrap gap-4 font-monospace text-xs text-faint-foreground">
                    <li>automation</li>
                    <li>python</li>
                    <li>database</li>
                </ul>
            </li>

            <li class="border-t border-border/50 py-8">
                <h2 class="section-heading">= Typst Blog Template + Vite Plugin</h2>
                <p class="mt-2 text-pretty text-dim-foreground">
                    The template and plugin that I built to create this blog. This is a
                    work-in-progress, so I'll just have a changelog here for now.
                </p>
                <ul class="mt-4 flex flex-wrap gap-4 font-monospace text-xs text-faint-foreground">
                    <li>svelte</li>
                    <li>typescript</li>
                    <li>typst</li>
                </ul>
            </li>
        </ul>
    </div>
</main>
