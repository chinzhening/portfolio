<script lang="ts">
    import '$lib/css/fonts.css';
    import '$lib/css/app.css';
    import Header from '$lib/components/Header.svelte';
    import Footer from '$lib/components/Footer.svelte';

    let { children } = $props();
</script>

<div>
    <Header />
    {@render children()}
    <Footer />
</div>
