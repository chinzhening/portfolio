<script lang="ts">
    import { goto } from '$app/navigation';
    import { gsap } from 'gsap';
    import { onMount, onDestroy } from 'svelte';
    import { socials, pages } from '$lib/config';
    import Verse from './Verse.svelte';

    const TOGGLE_LOCK_MS = 1000;
    const NAVIGATE_DELAY_MS = 50;

    let isOpen: boolean = $state(false);
    let hovered: boolean = $state(false);
    let locked: boolean = false;
    
    async function toggle() {
        if (locked) return;
        locked = true;
        isOpen = !isOpen;
        setTimeout(() => locked = false, TOGGLE_LOCK_MS);
    }

    let cross: {
        rotation: number;
        opacity: number;
        expanded: boolean;
    } = $state({
        rotation: 0,
        opacity: 1,
        expanded: false
    });

    let overlay: HTMLElement;
    let tl: gsap.core.Timeline | null = null;
    let isInitialized = $state(false);

    function closeMenu() {
        isOpen = false;
    }

    function navigate(href: string) {
        closeMenu();
        tl?.kill();
        setTimeout(() => goto(href), NAVIGATE_DELAY_MS);
    }

    const buildTimeline = () => {
        const timeline = gsap.timeline({
            paused: true,
            defaults: { ease: 'power2.out' }
        });

        gsap.set('.nav-links a, .nav-social a', { y: 18, opacity: 0 });
        gsap.set('.nav-footer', { opacity: 0 });

        timeline
            .to(overlay, { y: '0%', duration: 0.7 }, 0)
            .to(cross, {
                rotation: 45,
                opacity: 0.5,
                expanded: true,
                duration: 0.4
            }, 0.1)

            .fromTo('.page-link a',
                { x: -15, opacity: 0 },
                { x: 0, opacity: 1, duration: 0.7, stagger: 0.01 },
                '+=0.1'
            )

            .fromTo('.nav-social a',
                { x: 15, opacity: 0 },
                { x: 0, opacity: 1, duration: 0.8, stagger: 0.03 },
                '-=0.7'
            )
            .fromTo('.nav-footer',
                {y: 18, opacity: 0 },
                {y: 0, opacity: 1, duration: 0.8 },
                '-=0.55')

            .eventCallback("onReverseComplete", () => {
                gsap.set(overlay, { visibility: 'hidden' });
            });

        timeline.progress(0);

        return timeline;
    };

    onMount(() => {
        gsap.set(overlay, { y: '-100%', visibility: 'hidden' });
    });

    $effect(() => {
        if (!isInitialized && isOpen) {
            gsap.set(overlay, { visibility: 'visible' });
            tl = buildTimeline();
            isInitialized = true;
            tl.play();
            return;
        }

        if (!isInitialized) return;

        if (!tl) return;

        if (isOpen) {
            gsap.set(overlay, { visibility: 'visible' });
            tl.play();
        } else {
            tl.reverse();
        }
    });

    onDestroy(() => {
        tl?.kill();
    });
</script>

<div class="fixed top-0 left-0 right-0 z-150">
    <div class="container mx-auto px-0">
        <header class="fixed mt-8 mr-4 md:m-8 right-0">
            <button
                type="button"
                class="block w-16 h-16 md:w-24 md:h-24 cursor-pointer navicon {cross.expanded || hovered ? 'expanded' : ''}"
                style="transform: translateY({hovered ? -4 : 0}px); color: var(--cross); rotate: {cross.rotation}deg; opacity: {cross.opacity};"
                onclick={toggle}
                onmouseenter={() => hovered = true}
                onmouseleave={() => hovered = false}
                aria-label="Toggle navigation menu">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" fill="currentColor" class="overflow-visible">
                    <g>
                        <path class="arm-right" d="m16.86 12.21 3.97.02c.33.16.66.31.94.51.28.2.5.46.57.8.07.34-.03.76-.12 1.18l-.93.1c-.2-.08-.39-.17-.6-.24-.2-.07-.43-.13-.65-.18.35.49.7.98.98 1.33.27.34.47.55.66.76.38-.05.75-.1 1.08-.22.33-.11.61-.29.9-.72.27-.43.55-1.1.45-1.7-.1-.6-.56-1.12-1.02-1.64l1.2-.04c.12.02.24.03.34.1.1.08.18.22.33.31.15.1.36.15.6.07.22-.1.46-.32.7-.55l1.03-.78-1.23-1.27a2.04 2.04 0 0 0-.5-.19.97.97 0 0 0-.54.03c-.15.07-.24.2-.33.33-.12.08-.24.17-.51.2-.27.04-.7.04-1.11.03.02-.13.04-.26.13-.38.1-.11.26-.22.47-.46.2-.25.44-.62.48-1.08.03-.46-.14-1-.54-1.45a2.76 2.76 0 0 0-1.5-.9 1 1 0 0 0-.97.45c-.2.27-.27.56-.44.83-.17.27-.44.52-.72.77.29.02.57.03.8-.06.23-.09.4-.27.61-.34.21-.08.45-.04.7 0 .1.1.19.2.23.39.05.2.05.49.05.78-.18.32-.37.63-.64.87-.28.24-.65.41-1.03.58l-3.83-.03-1.73.9Z"/>
                        <path class="arm-left" d="m15.13 10.42-3.83.03c-.38-.17-.75-.34-1.03-.58-.27-.24-.46-.55-.64-.87 0-.3 0-.59.05-.78.04-.2.14-.29.23-.38.25-.05.49-.09.7-.01.2.07.38.25.6.34.24.09.52.08.8.06-.27-.25-.54-.5-.71-.77-.17-.27-.25-.56-.44-.83a1 1 0 0 0-.98-.44c-.47.06-1.1.43-1.49.89-.4.45-.57 1-.54 1.45.04.46.28.83.48 1.08.21.24.38.35.47.46.1.12.11.25.13.38-.42 0-.84.01-1.1-.03-.28-.03-.4-.12-.52-.2-.09-.13-.18-.26-.33-.33a.97.97 0 0 0-.54-.03c-.18.04-.34.11-.5.19l-1.23 1.27 1.02.78c.25.23.49.46.72.55.23.08.44.03.59-.07.15-.09.23-.23.33-.3.1-.08.22-.1.34-.11l1.2.04c-.46.52-.93 1.03-1.02 1.63-.1.6.18 1.28.46 1.71.28.43.56.6.9.72.32.12.7.17 1.07.22.2-.2.39-.42.66-.76.28-.35.63-.84.98-1.33-.22.05-.44.1-.65.18-.21.07-.4.16-.6.24l-.93-.1c-.1-.42-.19-.84-.12-1.18.06-.34.3-.6.57-.8.28-.2.6-.35.94-.5l3.97-.03 1.72-.9z"/>
                    </g>
                    <g>
                        <path class="arm-bottom" d="m15.14 12.21-.02 1.14c-.19.4-.38.82-.63 1.14-.25.33-.58.56-.9.8.43 2.7.86 5.4 1.25 8.1.4 2.72.74 5.85 1.16 8.58.42-2.73.77-5.86 1.16-8.58.39-2.7.82-5.4 1.25-8.1a4.28 4.28 0 0 1-.9-.8c-.25-.32-.44-.73-.63-1.14l-.02-1.14-.86-1.8z"/>
                        <path class="arm-top" d="m16 .01-.33.34-1.63 1.71c-.47.68-.94 1.35-1.18 1.9-.25.55-.27.97-.28 1.34-.02.38-.03.7.07.96a1 1 0 0 0 .56.52c.22.1.45.08.63.02s.32-.17.43-.28c.12-.12.21-.25.3-.38l-.38-.06a.78.78 0 0 1-.34-.18.36.36 0 0 1-.1-.33c.03-.14.11-.3.27-.38.15-.08.23-.08.58-.07.34 0 .33 0 .46.3.12.3.1.53.09 1.41-.02.89-.02 2.24-.02 3.6l.87 1.8.87-1.8s0-2.71-.02-3.6c-.01-.88-.03-1.12.1-1.41.12-.3.1-.3.45-.3s.43-.01.58.07c.16.07.24.24.27.38a.36.36 0 0 1-.1.33.78.78 0 0 1-.34.18l-.39.06.3.38c.12.11.26.22.44.28a1 1 0 0 0 1.19-.54c.1-.26.09-.58.07-.96-.01-.37-.03-.8-.28-1.34-.24-.55-.71-1.22-1.18-1.9L16.33.36 16 0"/>
                    </g>
                </svg>
            </button>
        </header>
    </div>
</div>

<nav bind:this={overlay} id="nav-overlay"
    class="fixed z-100 inset-0"
    >
    <div class="nav-inner
                relative z-10 h-full
                grid
                grid-cols-1 grid-rows-[auto]
                md:grid-cols-[minmax(0,1.2fr)_minmax(220px,0.8fr)]
                px-6 pt-24 pb-8
                md:px-12 md:pt-10 md:pb-10">

        <div class="nav-header md:col-span-2 flex flex-wrap items-end justify-between gap-3 pb-10 md:pb-12">
            <div>
                <p class="font-monospace text-[0.7rem] uppercase tracking-[0.35em] text-current/70">Navigation</p>
                <h2 class="mt-2 font-display text-3xl md:text-4xl italic">Index</h2>
            </div>
            <p class="max-w-[18rem] font-monospace text-[0.72rem] uppercase tracking-[0.2em] leading-5 text-current/65 text-right">
                Social links, lets connect!
            </p>
        </div>

        <!-- Left: page links -->
        <div class="nav-links
                    font-display text-2xl
                    flex flex-col gap-4 pt-1 md:pt-2
                    pl-4 md:pl-8 md:pr-10">
            {#each pages as page, index (page.name)}
                <div class="page-link md:py-4">
                    <a class="page-link__anchor inline-flex items-baseline gap-4" href={page.href} onclick={(e) => { e.preventDefault(); navigate(page.href); }}>
                        <span class="page-link__index pr-4">{String(index + 1).padStart(2, '0')}</span>
                        {page.name}
                    </a>
                </div>
            {/each}
        </div>

        <!-- Right: social links -->
        <div class="nav-social
                    flex flex-col justify-center gap-1
                    md:mt-0 md:border-l md:border-current/15 md:pl-10
                    text-right">
            {#each socials as social (social.name)}
                <div class="border-b border-current/10 pb-1">
                    <a href={social.href} target="_blank" rel="noopener">
                        {social.name}
                    </a>
                </div>
            {/each}
        </div>

        <!-- Footer -->
        <div class="nav-footer md:col-span-2 md:col-start-1 md:flex md:justify-end">
            <Verse open={isOpen}/>
        </div>  

    </div>
</nav>

<style>
    button.navicon {
        transition: transform 0.7s cubic-bezier(0.4, 0, 0.2, 1);
        transform-origin: 50% 28.6px;
    }

    .arm-right, .arm-left, .arm-top, .arm-bottom {
        transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        transform-origin: 16px 12.2px;
        transform: translate(0px, 0px);
    }

    .expanded .arm-right {
        transform: translateX(1.18px);
    }
    .expanded .arm-left {
        transform: translateX(-1.18px);
    }
    .expanded .arm-top {
        transform: translateY(-1.12px);
    }
    .expanded .arm-bottom {
        transform: translateY(1.12px);
    }


    /* Navigation links */
    #nav-overlay {
        color: color-mix(in oklab, var(--surface-1) 88%, var(--text-1) 12%);
        background:
            radial-gradient(circle at 14% 12%, color-mix(in oklab, var(--brand) 22%, transparent) 0%, transparent 34%),
            radial-gradient(circle at 88% 84%, color-mix(in oklab, var(--brand) 12%, transparent) 0%, transparent 28%),
            linear-gradient(135deg, color-mix(in oklab, var(--background) 84%, var(--surface-2) 16%), color-mix(in oklab, var(--background) 94%, var(--surface-1) 6%));
        isolation: isolate;
    }
    #nav-overlay::before {
        content: '';
        position: absolute;
        inset: 0;
        background:
            linear-gradient(90deg, transparent 0 12%, color-mix(in oklab, var(--border) 16%, transparent) 12% 12.5%, transparent 12.5% 87.5%, color-mix(in oklab, var(--border) 16%, transparent) 87.5% 88%, transparent 88%),
            linear-gradient(180deg, color-mix(in oklab, var(--surface-1) 10%, transparent), transparent 25%, color-mix(in oklab, var(--surface-1) 5%, transparent));
        opacity: 0.5;
        pointer-events: none;
    }

    /* Editorial panel layout */
    .nav-inner {
        width: min(1080px, calc(100vw - 1.5rem));
        margin: 0.75rem auto;
        height: calc(100% - 1.5rem);
        border: 1px solid color-mix(in oklab, var(--border) 42%, transparent);
        border-radius: 2rem;
        background:
            linear-gradient(180deg, color-mix(in oklab, var(--surface-1) 88%, var(--background) 12%), color-mix(in oklab, var(--surface-2) 80%, var(--background) 20%));
        box-shadow:
            0 24px 80px rgba(0, 0, 0, 0.35),
            inset 0 1px 0 rgba(255, 255, 255, 0.05);
        overflow: hidden;
        color: var(--text-1);
    }

    .nav-inner::after {
        content: '';
        position: absolute;
        inset: 1rem;
        border-radius: 1.5rem;
        border: 1px solid color-mix(in oklab, var(--border) 22%, transparent);
        pointer-events: none;
    }

    .nav-links a {
        color: var(--text-1);
        text-decoration: none;
        padding: 0.15rem 0;
        display: inline-block;
        transition: color 160ms ease, transform 160ms ease, letter-spacing 160ms ease;
    }

    .page-link__anchor {
        position: relative;
        width: 100%;
        padding-bottom: 0.15rem;
    }

    .page-link__index {
        min-width: 2ch;
        font-family: var(--font-monospace);
        font-size: 0.72em;
        letter-spacing: 0.22em;
        font-variant-numeric: tabular-nums;
        color: color-mix(in oklab, var(--text-1) 60%, var(--brand) 40%);
    }

    .page-link__anchor::after {
        content: '';
        position: absolute;
        left: 3.25rem;
        right: 0;
        bottom: 0;
        height: 1px;
        background: linear-gradient(90deg, color-mix(in oklab, var(--brand) 70%, transparent), transparent);
        transform: scaleX(0);
        transform-origin: left;
        transition: transform 220ms ease;
    }

    .page-link__anchor:hover::after,
    .page-link__anchor:focus-visible::after {
        transform: scaleX(1);
    }

    .nav-links a:hover {
        color: var(--brand);
        transform: translateX(4px);
        letter-spacing: 0.02em;
    }

    .nav-social a {
        color: var(--text-1);
        text-decoration: none;
        font-family: var(--font-monospace);
        font-size: 0.85rem;
        letter-spacing: 0.12em;
        text-transform: uppercase;
        transition: color 160ms ease, transform 160ms ease;
    }
    .nav-social a:hover {
        color: var(--brand);
        transform: translateX(-2px);
    }

    .nav-header {
        position: relative;
        z-index: 1;
        border-bottom: 1px solid color-mix(in oklab, var(--border) 18%, transparent);
    }
</style>