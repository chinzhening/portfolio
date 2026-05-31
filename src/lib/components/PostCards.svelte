<script lang="ts">
    import PostCard from '$lib/components/PostCard.svelte';

    let { posts } = $props();
</script>

<div class="grid grid-cols-1 gap-4 md:grid-cols-2 md:gap-6 xl:grid-cols-3 xl:gap-8">
    {#each posts as post, i (i)}
        <PostCard {post} index={i} />
    {/each}
</div>
