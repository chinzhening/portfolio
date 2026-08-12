<script lang="ts">
    let { content }: { content: string } = $props();
</script>

<aside class="callout side-note" role="note" aria-label="Side note">
    <div class="label" aria-hidden="true">Side note</div>
    {@html content}
</aside>
