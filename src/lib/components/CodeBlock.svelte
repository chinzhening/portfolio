<script lang="ts">
    import { gsap } from 'gsap';

    let {
        language,
        source,
        highlightedHtml
    }: {
        language: string;
        source: string;
        highlightedHtml: string;
    } = $props();

    let copied = $state(false);
    let isHovered = $state(false);
    let resetTimer: number | undefined;
    let copyButton = $state<HTMLButtonElement>();

    function animateCopyButton(opacity: number) {
        if (!copyButton) return;

        gsap.to(copyButton, {
            opacity,
            duration: 0.2,
            ease: 'power2.out',
            overwrite: true
        });
    }

    function showCopyButton() {
        isHovered = true;
        animateCopyButton(1);
    }

    function hideCopyButton() {
        isHovered = false;

        if (!copied) {
            animateCopyButton(0);
        }
    }

    $effect(() => {
        const button = copyButton;
        if (!button) return;
        gsap.set(button, { opacity: 0 });
        return () => {
            if (resetTimer) window.clearTimeout(resetTimer);
            gsap.killTweensOf(button);
        };
    });

    function renderHighlighted(node: HTMLElement, html: string) {
        node.innerHTML = html;

        return {
            update(nextHtml: string) {
                node.innerHTML = nextHtml;
            }
        };
    }

    async function copyToClipboard() {
        if (navigator.clipboard?.writeText) {
            await navigator.clipboard.writeText(source);
        } else {
            const textarea = document.createElement('textarea');
            textarea.value = source;
            textarea.setAttribute('readonly', 'true');
            textarea.style.position = 'fixed';
            textarea.style.left = '-9999px';
            document.body.append(textarea);
            textarea.select();
            document.execCommand('copy');
            textarea.remove();
        }

        copied = true;
        animateCopyButton(1);

        if (resetTimer) {
            window.clearTimeout(resetTimer);
        }

        resetTimer = window.setTimeout(() => {
            if (isHovered) {
                copied = false;
                resetTimer = undefined;
                return;
            }

            animateCopyButton(0);

            resetTimer = window.setTimeout(() => {
                copied = false;
                resetTimer = undefined;
            }, 200);
        }, 2400);
    }
</script>

<div
    role="group"
    aria-label={`${language} code`}
    class="code-block-card relative"
    onmouseenter={showCopyButton}
    onmouseleave={hideCopyButton}
>
    <div class="code-block-card__header">
        <div class="code-title">{language}</div>
        <button
            bind:this={copyButton}
            class="code-block-card__button inline-flex items-center justify-center relative isolate select-none transition-colors duration-300 ease-[cubic-bezier(0.165,0.85,0.45,1)] h-8 w-8 rounded-xl backdrop-blur-md bg-surface-1/90 text-foreground hover:cursor-pointer hover:bg-surface-2 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand/40 opacity-0"
            type="button"
            aria-label="Copy to clipboard"
            onclick={copyToClipboard}
            onfocus={showCopyButton}
            onblur={hideCopyButton}
        >
            <div class="relative">
                <div class="flex h-5 w-5 items-center justify-center">
                    {#if copied}
                        <svg
                            width="20"
                            height="20"
                            viewBox="0 0 20 20"
                            fill="currentColor"
                            xmlns="http://www.w3.org/2000/svg"
                            aria-hidden="true"
                            class="shrink-0"
                        >
                            <path
                                d="M15.188 5.11a.5.5 0 0 1 .752.626l-.056.084-7.5 9a.5.5 0 0 1-.738.033l-3.5-3.5-.064-.078a.501.501 0 0 1 .693-.693l.078.064 3.113 3.113 7.15-8.58z"
                            ></path>
                        </svg>
                    {:else}
                        <svg
                            width="20"
                            height="20"
                            viewBox="0 0 20 20"
                            fill="currentColor"
                            xmlns="http://www.w3.org/2000/svg"
                            aria-hidden="true"
                            class="shrink-0"
                        >
                            <path
                                d="M12.5 3A1.5 1.5 0 0 1 14 4.5V6h1.5A1.5 1.5 0 0 1 17 7.5v8a1.5 1.5 0 0 1-1.5 1.5h-8A1.5 1.5 0 0 1 6 15.5V14H4.5A1.5 1.5 0 0 1 3 12.5v-8A1.5 1.5 0 0 1 4.5 3zm1.5 9.5a1.5 1.5 0 0 1-1.5 1.5H7v1.5a.5.5 0 0 0 .5.5h8a.5.5 0 0 0 .5-.5v-8a.5.5 0 0 0-.5-.5H14zM4.5 4a.5.5 0 0 0-.5.5v8a.5.5 0 0 0 .5.5h8a.5.5 0 0 0 .5-.5v-8a.5.5 0 0 0-.5-.5z"
                            ></path>
                        </svg>
                    {/if}
                </div>
            </div>
        </button>
        <!-- Present from first render so the announcement is not missed. -->
        <div role="status" class="sr-only">{copied ? 'Copied to clipboard' : ''}</div>
    </div>
    <!-- Scrolls here, not on the injected <pre>, which cannot take a
         tabindex. Focusable per WCAG 2.1.1. -->
    <!-- svelte-ignore a11y_no_noninteractive_tabindex -->
    <div
        class="code-block-card__body"
        tabindex="0"
        role="region"
        aria-label={`${language} source`}
        use:renderHighlighted={highlightedHtml}
    ></div>
</div>

<style>
    .code-block-card {
        margin-block: 1.5rem;
        overflow: hidden;
        background: var(--background);
    }

    .code-block-card__header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding-inline: 0.75rem;
        padding-block: 0.2rem;
    }

    .code-block-card__button {
        flex: none;
    }

    .code-title {
        display: flex;
        align-items: center;
        font-family: var(--font-monospace);
        font-size: 0.8rem;
        font-weight: bold;
        letter-spacing: 0.05rem;
        text-transform: uppercase;
        line-height: 1;
        color: var(--text-2);
    }

    /* The single scroll container, both axes. The <pre> no longer scrolls. */
    .code-block-card__body {
        max-height: 800px;
        overflow: auto;
    }

    .code-block-card__body:focus-visible {
        outline: 2px solid var(--brand);
        outline-offset: -2px;
    }

    .code-block-card__body :global(pre[class*='shiki']) {
        font-size: 0.875rem;
        line-height: 1.6;
        padding: 0.75rem;
        border-radius: 5px;
        box-shadow: none;
        margin: 0;
        /* Keeps the highlighter background covering the full scroll width. */
        width: max-content;
        min-width: 100%;
    }
</style>
