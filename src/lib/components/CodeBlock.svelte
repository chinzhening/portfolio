<script lang="ts">
    import { gsap } from 'gsap';
    import { onDestroy, onMount } from 'svelte';

    let {
        language,
        source,
        highlightedHtml,
    }: {
        language: string;
        source: string;
        highlightedHtml: string;
    } = $props();

    let copied = $state(false);
    let isHovered = $state(false);
    let resetTimer: number | undefined;
    let copyButton: HTMLButtonElement | undefined;

    function animateCopyButton(opacity: number) {
        if (!copyButton) return;

        gsap.to(copyButton, {
            opacity,
            duration: 0.2,
            ease: 'power2.out',
            overwrite: true,
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

    onMount(() => {
        if (copyButton) {
            gsap.set(copyButton, { opacity: 0 });
        }
    });

    function renderHighlighted(node: HTMLElement, html: string) {
        node.innerHTML = html;

        return {
            update(nextHtml: string) {
                node.innerHTML = nextHtml;
            },
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

    onDestroy(() => {
        if (resetTimer) {
            window.clearTimeout(resetTimer);
        }

        if (copyButton) {
            gsap.killTweensOf(copyButton);
        }
    });
</script>

<div role="group" aria-label={`${language} code`} class="code-block-card relative border border-border/15 rounded-lg bg-surface-1/60" onmouseenter={showCopyButton} onmouseleave={hideCopyButton}>
    <div class="code-block-card__header">
        <div class="code-title">{language}</div>
        <button
            bind:this={copyButton}
            class="code-block-card__button inline-flex items-center justify-center relative isolate shrink-0 can-focus select-none disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none disabled:drop-shadow-none border-transparent transition font-base duration-300 ease-[cubic-bezier(0.165,0.85,0.45,1)] h-8 w-8 rounded-md backdrop-blur-md bg-surface-1/90 text-text-1 cursor-default hover:cursor-pointer hover:bg-surface-2 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand/40 opacity-0"
            type="button"
            aria-label="Copy to clipboard"
            aria-pressed={copied}
            data-state={copied ? 'open' : 'closed'}
            onclick={copyToClipboard}
            onfocus={showCopyButton}
            onblur={hideCopyButton}
        >
            <div class="relative">
                <div class="copy-button__icon flex items-center justify-center" style="width: 20px; height: 20px;">
                    {#if copied}
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" style="flex-shrink: 0;">
                            <path d="M15.188 5.11a.5.5 0 0 1 .752.626l-.056.084-7.5 9a.5.5 0 0 1-.738.033l-3.5-3.5-.064-.078a.501.501 0 0 1 .693-.693l.078.064 3.113 3.113 7.15-8.58z"></path>
                        </svg>
                    {:else}
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" style="flex-shrink: 0;">
                            <path d="M12.5 3A1.5 1.5 0 0 1 14 4.5V6h1.5A1.5 1.5 0 0 1 17 7.5v8a1.5 1.5 0 0 1-1.5 1.5h-8A1.5 1.5 0 0 1 6 15.5V14H4.5A1.5 1.5 0 0 1 3 12.5v-8A1.5 1.5 0 0 1 4.5 3zm1.5 9.5a1.5 1.5 0 0 1-1.5 1.5H7v1.5a.5.5 0 0 0 .5.5h8a.5.5 0 0 0 .5-.5v-8a.5.5 0 0 0-.5-.5H14zM4.5 4a.5.5 0 0 0-.5.5v8a.5.5 0 0 0 .5.5h8a.5.5 0 0 0 .5-.5v-8a.5.5 0 0 0-.5-.5z"></path>
                        </svg>
                    {/if}
                </div>
            </div>
        </button>
    </div>
    <div class="code-block-card__content">
        <div class="code-block-card__body overflow-x-auto" use:renderHighlighted={highlightedHtml}></div>
    </div>
</div>

<style>
    .code-block-card__header {
        display: flex;
        align-items: center;
        font-weight: bold;
        justify-content: space-between;
        letter-spacing: 0.05rem;
        padding: 0.5rem 0.75rem;
        background: var(--background);
    }

    .code-block-card__button {
        flex: none;
        margin-left: auto;
    }

    .code-title {
        display: flex;
        align-items: center;
        font-family: var(--font-monospace);
        font-size: 0.8rem;
        letter-spacing: 0.05rem;
        text-transform: uppercase;
        line-height: 1;
        color: var(--text-2);
    }

    .code-block-card__content {
        background: var(--background);
    }

    .code-block-card__body {
        padding: 0;
        background: var(--background);
    }

    .code-block-card__body :global(pre[class*='shiki']) {
        max-height: 800px;
        font-size: 0.875rem;
        line-height: 1.6;
        overflow-x: auto;
        padding: 1rem;
        border: 0;
        border-top: 1px solid var(--border);
        border-radius: 0 0 0.75rem 0.75rem;
        box-shadow: none;
        margin: 0;
        background: var(--background) !important;
        width: 100%;
    }
</style>