<script lang="ts">
    import Seo from '$lib/components/Seo.svelte';
</script>

<Seo title="Projects" path="/projects" />

<main id="main" class="page-prose">
    <div class="page-content">
        <p class="mt-8 pt-8">
            A curation of personal projects and documented open-source contributions.
        </p>
        <p>Warning: this is still a massive work-in-progress.</p>
        <h1>Typst</h1>
        <ul>
            <li>
                <a
                    href="https://github.com/typst/typst/pull/9016"
                    target="_blank"
                    rel="noopener noreferrer">PR #9016 (10-26-2026)</a
                >
                : Fix invalid SVG output with text content in tiling
            </li>
            <li>
                <a
                    href="https://github.com/typst/typst/pull/8992"
                    target="_blank"
                    rel="noopener noreferrer">PR #8992 (10-23-2026)</a
                >
                : Fix spread argument override in typed HTML constructor
            </li>
            <li>
                <a
                    href="https://github.com/typst/typst/pull/8963"
                    target="_blank"
                    rel="noopener noreferrer">PR #8963 (10-16-2026)</a
                >
                : Remove tracking from the last glyph in a line
            </li>
        </ul>

        <h1 class="section-heading">Squaredle Solver</h1>
        <p class="mt-2 text-pretty text-dim-foreground">
            A program that plays the popular daily <a
                href="https://squaredle.app"
                target="_blank"
                rel="noopener noreferrer">Squaredle</a
            > puzzle on its own and files every run into a database. The Python script shells out to a
            solver written in C++ that uses a trie-routed backtracking algorithm to find every word that
            satisfies the constraints. This was a fun exercise that challegend me to learn benchmarking
            practices, optimization techniques, and data plumbing. From the first pointer-based trie implementation,
            I improved the solver to use a serializable, compact, sparse flat trie that reduced the runtime
            from ~150ms to ~4ms per puzzle on my machine.
        </p>
        <p class="mt-4 text-pretty text-dim-foreground">
            I tested several approaches to squeeze the most performance out of my solver, before
            settling on the sparse flat trie, with an implementation (serialization format) that
            uses bitset operations to check for child nodes. Writing a blog post for this has been
            on the backburner for a while, but I plan to write one soon to share my learnings. These
            are the kinds of things you don't normally learn in a typical DSA course.
        </p>
        <ul class="mt-4 flex flex-wrap gap-6 font-monospace text-xs text-faint-foreground">
            <li>automation</li>
            <li>python</li>
            <li>database</li>
        </ul>

        <h1 class="section-heading">Tyquire</h1>
        <p class="mt-2 text-pretty text-dim-foreground">
            The Svelte blog template and Vite plugin that I crafted for this blog. This is a
            work-in-progress, so I'll just have a changelog here for now.
        </p>
        <h2>changelog</h2>
        <ul>
            <li>
                10-28-2026 - v0.1.0 - initial release. available at <a
                    href="https://github.com/typst/tyquire-template"
                    target="_blank"
                    rel="noopener noreferrer">GitHub</a
                >
            </li>
            <li>
                09-08-2026 - tyquire plugin converts typst html export into a typed component tree
                that is rendered using the svelte snippet engine
            </li>
            <li>08-14-2026 - first working exported html to blog pipeline</li>
        </ul>
        <ul class="mt-4 flex flex-wrap gap-6 font-monospace text-xs text-faint-foreground">
            <li>svelte</li>
            <li>typescript</li>
            <li>typst</li>
        </ul>
    </div>
</main>
