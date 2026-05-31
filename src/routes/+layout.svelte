<script lang="ts">	
	import '$lib/css/fonts.css'
	import '$lib/css/app.css';
	import Header from '$lib/components/Header.svelte';
	import Footer from '$lib/components/Footer.svelte';

	let { children } = $props();

</script>

<div class="site-backdrop">
	<Header />
	<div class="site-backdrop__glow site-backdrop__glow--left" aria-hidden="true"></div>
	<div class="site-backdrop__glow site-backdrop__glow--right" aria-hidden="true"></div>
	{@render children()}
	<Footer />
</div>

<style>
	.site-backdrop {
		position: relative;
		min-height: 100vh;
		overflow: hidden;
		background:
			radial-gradient(circle at top left, color-mix(in oklab, var(--brand) 14%, transparent) 0, transparent 28%),
			radial-gradient(circle at bottom right, color-mix(in oklab, var(--text-1) 8%, transparent) 0, transparent 30%),
			linear-gradient(180deg, color-mix(in oklab, var(--surface-1) 94%, var(--background) 6%), var(--background));
	}

	.site-backdrop::before {
		content: "";
		position: absolute;
		inset: 0;
		background-image: linear-gradient(rgba(0, 0, 0, 0.02) 1px, transparent 1px), linear-gradient(90deg, rgba(0, 0, 0, 0.02) 1px, transparent 1px);
		background-size: 30px 30px;
		mask-image: linear-gradient(180deg, rgba(0, 0, 0, 0.55), transparent 80%);
		pointer-events: none;
	}

	.site-backdrop__glow {
		position: absolute;
		inset: auto;
		width: 20rem;
		height: 20rem;
		border-radius: 9999px;
		opacity: 0.45;
		filter: blur(50px);
		pointer-events: none;
	}

	.site-backdrop__glow--left {
		top: 5rem;
		left: -5rem;
		background: color-mix(in oklab, var(--brand) 20%, transparent);
	}

	.site-backdrop__glow--right {
		right: -6rem;
		bottom: 4rem;
		background: color-mix(in oklab, var(--text-1) 10%, transparent);
	}
</style>
