import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite';

import typstToSvelte from './plugins/tyquire/src/index';

export default defineConfig({
    plugins: [typstToSvelte(), tailwindcss(), sveltekit()]
});
