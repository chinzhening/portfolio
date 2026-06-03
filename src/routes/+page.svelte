<script lang="ts">
    import { resolve } from '$app/paths';
    import * as config from '$lib/config';
    import { animate, fadeUp } from '$lib/animations';
    import HomeNoteCard from '$lib/components/HomeNoteCard.svelte';
    import LinkButton from '$lib/components/LinkButton.svelte';
    import TagChip from '$lib/components/TagChip.svelte';
    import Typing from '$lib/components/Typing.svelte';

    const roles = [
        "creator.",
        "student.",
        "developer.",
        "ai enthusiast."
    ];

    function getGreeting() {
        const hour = new Date().getHours();
        if (6 <= hour && hour < 12) return "Morning";
        else if (12 <= hour && hour < 18) return "Afternoon";
        else return "Evening";
    }

</script>

<svelte:head>
    <title>Blog | {config.name}</title>
</svelte:head>

<main class="home-postcard min-h-screen overflow-hidden py-16 md:py-24">

    <section class="container mx-auto px-4 md:px-8">
        <div class="home-postcard__sheet mx-auto max-w-6xl overflow-hidden border-1 border-border/15 bg-surface-1 shadow-[0_24px_80px_rgba(0,0,0,0.14)]">
            <div class="grid lg:grid-cols-[1.15fr_0.85fr]">
                <div class="relative px-6 py-8 sm:px-8 md:px-10 md:py-10 lg:px-12 lg:py-12">
                    <div class="mb-8 flex items-start justify-between gap-6">
                        <div>
                            <p class="font-monospace text-xs uppercase tracking-[0.3em] text-muted-foreground">
                                postcard from
                            </p>
                            <p class="mt-2 font-monospace text-sm tracking-[0.18em] text-muted-foreground">
                                {config.name}
                            </p>
                        </div>

                        <TagChip variant="postcard" href={resolve("/resume.pdf")} download="resume.pdf">
                            <span>download</span>
                            <span>resume</span>
                            <svg class="inline-block mt-1" width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false">
                                <polyline points="0,0 2,1 4,0" transform="translate(6,6) scale(3,3)" stroke="currentColor" stroke-width="0.33" fill="none" stroke-linecap="square" stroke-linejoin="round" />
                                <polyline points="0,0 2,1 4,0" transform="translate(6,12) scale(3,3)" stroke="currentColor" stroke-width="0.33" fill="none" stroke-linecap="square" stroke-linejoin="round" />
                            </svg>
                        </TagChip>
                    </div>

                    <div class="max-w-3xl" use:animate={fadeUp}>
                        <p class="font-monospace text-sm uppercase tracking-[0.25em] text-muted-foreground">
                            {getGreeting()}
                        </p>
                        <h1 class="mt-5 text-balance font-display text-5xl leading-none font-light tracking-tight text-foreground md:text-7xl">
                            I'm {config.name},
                            <span class="home-postcard__headline-accent">writing from the edge of the feed.</span>
                        </h1>
                        <h2 class="home-postcard__typing-slot mt-6 max-w-2xl text-pretty font-monospace text-lg leading-relaxed text-muted-foreground md:text-2xl line-clamp-3">
                            i'm a
                            <span class="inline-block align-baseline text-brand">
                                <Typing words={roles} typeSpeed={200} cursor="block" />
                            </span>
                            keeping this blog as a living stack of experiments, notes, and finished things.
                        </h2>

                        <p class="mt-8 max-w-xl text-pretty text-base leading-8 text-muted-foreground md:text-lg" use:animate={fadeUp}>
                            {config.status}
                        </p>

                        <div class="mt-10 flex flex-wrap gap-3" use:animate={fadeUp}>
                            <LinkButton href={resolve('/posts')}>
                                browse posts
                            </LinkButton>
                            <LinkButton href={resolve('/projects')} variant="ghost">
                                view projects
                            </LinkButton>
                        </div>
                    </div>
                </div>

                <div class="home-postcard__panel border-t-1 border-border/12 bg-surface-2 px-6 py-8 sm:px-8 md:px-10 lg:border-l-1 lg:border-t-0 lg:px-10 lg:py-12">
                    <div class="home-postcard__panel-frame h-full" use:animate={fadeUp}>
                        <div class="flex h-full flex-col gap-8">
                            <div>
                                <p class="font-monospace text-xs uppercase tracking-[0.3em] text-muted-foreground">
                                    address side
                                </p>
                                <h3 class="mt-3 font-display text-3xl leading-tight text-foreground md:text-4xl">
                                    I like tools with a bit of paper texture.
                                </h3>
                            </div>

                            <div class="space-y-5 text-base leading-8 text-muted-foreground">
                                <p>
                                    Welcome to my portfolio. I grew up in <strong>New Zealand</strong> and have been living in Singapore for the past four years.
                                </p>
                                <p>
                                    This blog is where I stash ideas, ship small experiments, and keep track of the things worth revisiting.
                                </p>
                            </div>

                            <div class="mt-auto grid gap-4 border-t-1 border-dashed border-border/15 pt-6 text-sm text-muted-foreground">
                                <div class="flex items-center gap-4">
                                    <span class="w-1/3 font-monospace uppercase tracking-[0.2em] font-bold text-right">origin</span>
                                    <span class="w-2/3">A quiet desk, a warm cup of coffee, and a browser tab too many.</span>
                                </div>
                                <div class="flex items-center gap-4">
                                    <span class="w-1/3 font-monospace uppercase tracking-[0.2em] font-bold text-right">destination</span>
                                    <span class="w-2/3">Useful posts, experiments, and a few polished projects.</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="container mx-auto px-4 pb-8 pt-10 md:px-8 md:pt-14">
        <div class="mx-auto grid max-w-6xl gap-5 lg:grid-cols-2">
            <HomeNoteCard eyebrow="about me">
                <h2 class="text-balance font-display text-3xl leading-tight font-medium text-foreground md:text-[2.5rem]">
                    My research interests include <strong>applied mathematics</strong>, <strong>optimization</strong>, <strong>data modelling</strong>, and software development.
                </h2>
            </HomeNoteCard>

            <HomeNoteCard eyebrow="back of the card" soft={true}>
                <div class="business-card">
                    <span class="font-display">Nothing here yet ...</span>
                </div>
            </HomeNoteCard>
        </div>
    </section>
</main>

<style>
strong {
    font-weight: inherit;
    color: var(--brand);
}

.home-postcard {
    position: relative;
}

.home-postcard__sheet {
    position: relative;
    border-radius: 2rem;
    transform: rotate(-0.8deg);
}

.home-postcard__sheet::after {
    content: "";
    position: absolute;
    inset: 12px;
    border: 1px solid color-mix(in oklab, var(--border) 45%, transparent);
    border-radius: calc(2rem - 12px);
    pointer-events: none;
}

.home-postcard__panel {
    position: relative;
}

.home-postcard__panel-frame {
    position: relative;
    padding: 1.25rem;
    border-radius: 1.5rem;
    background:
        linear-gradient(180deg, color-mix(in oklab, var(--surface-1) 75%, transparent), transparent),
        repeating-linear-gradient(180deg, transparent 0, transparent 1.65rem, color-mix(in oklab, var(--border) 22%, transparent) 1.65rem, color-mix(in oklab, var(--border) 22%, transparent) 1.72rem);
    border: 1px solid color-mix(in oklab, var(--border) 45%, transparent);
}

.home-postcard__headline-accent {
    display: block;
    margin-top: 0.45rem;
    max-width: 11ch;
    font-size: 0.56em;
    line-height: 1.1;
    font-family: var(--font-monospace);
    text-transform: uppercase;
    letter-spacing: 0.2em;
    color: var(--text-2);
}

.home-postcard__typing-slot {
    min-height: 5.5rem;
}

@media (min-width: 768px) {
    .home-postcard__typing-slot {
        min-height: 7.4rem;
    }
}

/* business-card styling for back of the card */
.business-card {
    /* rely on HomeNoteCard for outer padding/background */
    padding: 0;
    border-radius: 0;
    position: relative;
    overflow: visible;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
}

@media (max-width: 1023px) {
    .home-postcard__sheet {
        transform: rotate(0deg);
    }
}
</style>
