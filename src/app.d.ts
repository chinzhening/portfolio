import type { PostMetadata } from '$lib/types';
import type { TypstDocument } from '$tyquire';

declare module '*.typ' {
    const content: TypstDocument<PostMetadata>;
    export default content;
}

// See https://svelte.dev/docs/kit/types#app.d.ts
// for information about these interfaces
declare global {
    namespace App {
        // interface Error {}
        // interface Locals {}
        // interface PageData {}
        // interface PageState {}
        // interface Platform {}
    }
}

export {};
