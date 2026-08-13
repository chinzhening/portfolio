<script lang="ts">
    let {
        id,
        content,
        caption
    }: {
        id?: string;
        content: string;
        caption?: string;
    } = $props();
</script>

<!-- Styled from article.css under `.typst`, like SideNote. -->
<figure {id} class="figure-block">
    <div class="figure-frame">
        {@html content}
    </div>
    {#if caption}
        <figcaption>
            {@html caption}
        </figcaption>
    {/if}
</figure>
