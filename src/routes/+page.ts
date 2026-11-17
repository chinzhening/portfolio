import { getPosts } from '#lib/posts.ts';

export async function load() {
    return {
        posts: getPosts().slice(0, 3)
    };
}
