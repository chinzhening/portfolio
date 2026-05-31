import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite';

import typstToSvelte from './plugins/typst-svelte';

export default defineConfig({
	plugins: [
		typstToSvelte(),
		tailwindcss(),
		sveltekit()
	]
});
