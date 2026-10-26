<script lang="ts">
    import type { Snippet } from 'svelte';
    let {
        children,
        class: className = ''
    }: {
        children?: Snippet;
        class?: string;
    } = $props();
</script>

<aside class="xl:outer">
    <div class={['xl:inner', className]}>
        {@render children?.()}
    </div>
</aside>

<style>
    @import 'tailwindcss';
    @utility outer {
        border: 0;
        margin: 0;
        padding: 0;
        position: absolute;
        top: 0;
        bottom: 0;
        left: calc(100% + 48px);
    }
    @utility inner {
        max-height: calc(100vh - 64px);
        position: sticky;
        top: 32px;
        overflow-y: auto;
    }
</style>
