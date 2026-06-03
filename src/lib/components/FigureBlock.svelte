<script lang="ts">
    let {
        id,
        content,
        caption,
    }: {
        id?: string;
        content: string;
        caption: string | null;
    } = $props();
</script>

<figure id={id}>
    <div class="container">
        {@html content}
    </div>
    {#if caption}
    <figcaption>
        {@html caption}
    </figcaption>
    {/if}
</figure>

<style>
    .container {
        width: 100%;
        overflow-x: auto;
        padding: 0.5rem 0.75rem;
        box-sizing: border-box;
        display: block;
    }

    figure {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 1.5rem;
    }

    figcaption {
        font-family: var(--font-system-ui);
        font-size: 0.875rem;
        line-height: 1.5;
        text-wrap: pretty;
        max-width: 70ch;
    }
</style>