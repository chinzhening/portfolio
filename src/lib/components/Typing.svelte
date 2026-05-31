<script lang="ts">
    type Props = {
        words: string[];
        typeSpeed?: number;
        deleteSpeed?: number;
        pauseDelay?: number;
        loop?: boolean;
        cursor?: "line" | "block" | "underscore";
        blink?: boolean;
    };

    let {
        words,
        typeSpeed = 100,
        deleteSpeed = 80,
        pauseDelay = 1000,
        loop = true,
        cursor = "line",
        blink = true,
    }: Props = $props();

    let displayedText = $state('');

    const sleep = (ms: number) => new Promise<void>((r) => setTimeout(r, ms));

    $effect(() => {
        let cancelled = false;

        const run = async () => {
        let wordIndex = 0;
        let charIndex = 0;
        let isDeleting = false;

        while (!cancelled) {
            const current = words[wordIndex];
            if (!current) return;

            if (!isDeleting) {
            if (charIndex < current.length) {
                charIndex++;
                displayedText = current.slice(0, charIndex);
                await sleep(typeSpeed);
            } else {
                if (!loop && wordIndex === words.length - 1) return;
                isDeleting = true;
                await sleep(pauseDelay);
            }
            } else {
            if (charIndex > 0) {
                charIndex--;
                displayedText = current.slice(0, charIndex);
                await sleep(deleteSpeed);
            } else {
                isDeleting = false;
                wordIndex = (wordIndex + 1) % words.length;
                await sleep(typeSpeed);
            }
            }

            if (cancelled) break;
        }
        };

        run();

        return () => {
            cancelled = true;
        };
    });
</script>

<span>
{displayedText}<span class="cursor" class:blink data-cursor={cursor}>
    {cursor === 'block' ? ('*') : cursor === 'underscore' ? '_' : '|'}
</span>
</span>

<style>
.cursor {
    display: inline-block;
    margin-left: 1px;
}

.cursor[data-cursor='block'] {
    background: currentColor;
    height: 1.1em;
    vertical-align: baseline;
    margin-left: 0;
}

.cursor.blink {
    animation: blink 0.8s infinite;
}

@keyframes blink {
    50% { opacity: 0; }
}
</style>