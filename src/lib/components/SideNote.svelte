<script lang="ts">
    let {
        content,
    }: {
        content: string;
    } = $props();
</script>

<aside
    class="side-note relative my-10 grid min-h-[4.5rem] grid-cols-1 gap-[0.35rem]
        -mx-6 w-[calc(100%+3rem)] rounded-none border-y border-border bg-surface-1
        px-6 pt-12 pb-6 text-[1rem] italic leading-[1.5rem]
        shadow-none
        sm:mx-0 sm:w-full sm:rounded-[0.75rem] sm:border sm:shadow-[0_1.25rem_2.5rem_oklch(from_var(--text-1)_l_c_h_/_0.06)]
        lg:px-7 lg:pt-8 lg:pb-7"
    role="note"
    aria-label="Side note"
>
    <div
        class="label absolute top-6 left-4 z-10 block -translate-y-1/2 bg-background px-[0.6rem] py-[0.35rem]
            font-monospace text-[1rem] font-normal not-italic uppercase leading-none tracking-[0.05rem] text-text-2"
    >
        Side note
    </div>
    <div class="content [&_p]:m-0 [&_em]:not-italic [&_i]:not-italic [&_code]:not-italic">
        {@html content}
    </div>
</aside>
