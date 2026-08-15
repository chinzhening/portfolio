import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite';

import tyquire from './plugins/tyquire/src/index.ts';

export default defineConfig({
    plugins: [tyquire(), tailwindcss(), sveltekit()]
});
