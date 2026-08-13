<script lang="ts">
    let {
        id,
        content,
        caption
    }: {
        id?: string;
        content: string;
        caption: string | null;
    } = $props();
</script>

<figure {id} class="my-4">
    <div class="figure-frame">
        {@html content}
    </div>
    {#if caption}
        <figcaption>
            {@html caption}
        </figcaption>
    {/if}
</figure>

<style>
    figure {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
    }

    /* Not `.container`: that is a Tailwind utility, emitted because the post
       route uses it, and it would add breakpoint max-widths this rule does
       not override. */
    .figure-frame {
        width: 100%;
        overflow-x: auto;
        box-sizing: border-box;
        display: flex;
        justify-content: safe center;
    }

    figcaption {
        font-family: var(--font-system-ui);
        font-size: 0.875rem;
        line-height: 1.5;
        text-wrap: pretty;
        max-width: 70ch;
    }
</style>
