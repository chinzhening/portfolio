<script lang="ts">
    type Verse = {
        text: string;
        ref: string;
    };

    let { open } = $props();

    const verses: Verse[] = [
        { text: "Give me understanding, and I will keep your law and obey it with all my heart.", ref: "Psalm 119:34" },
        { text: "Your word is a lamp to my feet and a light to my path.", ref: "Psalm 119:105" },
        { text: "I have hidden your word in my heart that I might not sin against you.", ref: "Psalm 119:11" },
        { text: "The unfolding of your words gives light; it gives understanding to the simple.", ref: "Psalm 119:130" },
    ];

    function getVerse() {
        const index = Math.floor(Math.random() * verses.length);
        return verses[index];
    }

    let verse: Verse = $state(getVerse());
    let previousOpen = $derived(open);

    $effect(() => {
        if (open && !previousOpen) {
            verse = getVerse();
        }
        previousOpen = open;
    });
</script>

<div class="nav-footer__quote hidden md:block text-center font-serif
            mt-6 mb-4 md:mt-12 md:mb-6
            w-full max-w-[calc(100vw-2rem)] md:max-w-[min(32rem,calc(100vw-3rem))]">
    <h6 class="italic text-6 leading-loose">"{verse.text}"</h6>
    <h3 class="text-[0.65rem] md:text-xs text-right mt-2 md:mt-4 font-monospace uppercase tracking-[0.18em] leading-tight whitespace-normal break-words"> - {verse.ref}</h3>
</div>

<style>
    .nav-footer__quote {
        padding: 1.25rem 1.25rem 1.1rem;
        border-radius: 1.5rem;
        border: 1px solid color-mix(in oklab, var(--border) 20%, transparent);
        background: color-mix(in oklab, var(--surface-3) 62%, transparent);
        box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.04);
    }

    h6 {
        color: var(--text-1);
        opacity: 0.95;
    }
</style>