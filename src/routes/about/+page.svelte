<script lang="ts">
    import * as config from '$lib/config';
</script>

<svelte:head>
    <title>About | {config.title}</title>
</svelte:head>

<main id="main" class="bg-background">
    <div class="mx-auto px-6 max-w-3xl">
        <header class="py-8 font-monospace">
            <p class="mt-4 text-faint-foreground">```</p>
            <p class="text-pretty">
                I grew up in New Zealand but have been based in Singapore since 2022. In 2026, I
                graduated from the National University of Singapore with a B.Sc. in Mathematics.
            </p>
            <p class="mt-4">
                University is where applied mathematics and software stopped being separate subjects
                for me.
            </p>
            <p class="mt-2 text-faint-foreground">```</p>
        </header>
    </div>
</main>
