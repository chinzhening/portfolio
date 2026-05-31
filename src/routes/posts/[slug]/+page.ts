import { error } from '@sveltejs/kit'

export const entries = () => {
    const modules = import.meta.glob('$lib/content/*.typ', { eager: true })
    
    return Object.keys(modules).map((path) => ({
        slug: path.split('/').at(-1)!.replace('.typ', '')
    }))
}

// +page.ts
export async function load({ params }) {
    try {
        const { default: { html, metadata } } = await import(`../../../lib/content/${params.slug}.typ`)
        return { html, metadata }
    } catch {
        error(404)
    }
}