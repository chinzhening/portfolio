<script lang="ts">
    import type { TypstComponentProps } from '$tyquire/svelte/types';

    let { children }: TypstComponentProps = $props();
</script>

<aside class="callout side-note" role="note" aria-label="Side note">
    <div class="label" aria-hidden="true">Side note</div>
    {@render children()}
</aside>
