<script lang="ts">
    import type { TypstComponentProps } from '$tyquire/svelte/types';
    let { props, children, slots, renderNodes }: TypstComponentProps = $props();
</script>

<figure id={props.id as string | undefined} class="figure-block">
    <div class="figure-frame">
        {@render children()}
    </div>
    {#if slots.caption}
        <figcaption>
            {@render renderNodes(slots.caption)}
        </figcaption>
    {/if}
</figure>
