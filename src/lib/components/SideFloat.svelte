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

<aside class="outer">
    <div class={['inner', className]}>
        {@render children?.()}
    </div>
</aside>

<style>
    .outer {
        border: 0;
        margin: 0;
        padding: 0;
        position: absolute;
        top: 0;
        bottom: 0;
        left: calc(100% + 48px);
    }
    .inner {
        max-height: calc(100vh - 64px);
        position: sticky;
        top: 32px;
        overflow-y: auto;
    }

    @media (width < 80rem) {
        .outer {
            position: static;
        }

        .inner {
            max-height: none;
            position: static;
            overflow: visible;
        }
    }
</style>
