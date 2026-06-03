<script>
	import PostCards from "$lib/components/PostCards.svelte";
    import LinkButton from '$lib/components/LinkButton.svelte';

    import { resolve }from '$app/paths';
    import { title } from '$lib/config';

    let { data } = $props();

</script>

<svelte:head>
    <title>All Posts | {title}</title>
</svelte:head>

<div class="bg-background min-h-screen">
    <main class="pt-32 pb-24 md:pt-40">
        <header class="container mx-auto mb-20 px-6 md:px-12 lg:px-20">
            <div class="mx-auto max-w-6xl">
                <LinkButton href={resolve('/')} variant="back" className="mb-12">
                    <span class="inline-flex items-center justify-center text-[0.85rem] leading-none" aria-hidden="true">&laquo;</span>
                    <span>Home</span>
                </LinkButton>
                <!-- Main title with decorative elements -->
                <div class="relative">
                    <!-- Issue number - decorative -->
                    <span
                        class="text-foreground/[0.04] pointer-events-none absolute hidden md:block text-[4rem] leading-none select-none md:-left-20 md:top-8 md:text-[6rem]
                            font-display font-thin">
                            03
                    </span>

                    <h1
                        class="text-muted-foreground text-6xl leading-[0.9] tracking-tight text-balance md:text-8xl lg:text-9xl
                            font-display font-light">
                        Posts
                    </h1>

                    <div class="mt-4 flex items-center gap-2">
                        <div class="w-4"></div>
                        <p class="text-muted-foreground text-md tracking-[0.15em] text-pretty uppercase">
                            Thoughts, abstraction & meaning.
                        </p>
                    </div>
                </div>
            </div>
        </header>
        <section class="container mx-auto px-6 md:px-12 lg:px-20">
            <div class="mx-auto max-w-6xl">
                <PostCards posts={data.posts}/>
            </div>
        </section>
    </main>
</div>

