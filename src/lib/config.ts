import { resolve } from '$app/paths';

export const title = "Chin Zhe Ning | Portfolio";
export const name = "Zhe Ning";
export const status = `seeking opportunities in AI and ML research and development in Singapore.`;
export const year = 2026;
export const pages: { name: string; href: string }[] = [
    { name: 'Writing', href: resolve(`/posts`) },
    { name: 'Projects', href: resolve(`/projects`) },
    { name: 'About', href: resolve(`/about`) },
];
export const socials: { name: string; href: string }[] = [
    { name: 'GitHub', href: 'https://github.com/chinzhening' },
    { name: 'LinkedIn', href: 'https://linkedin.com/in/chinzhening' },
    { name: 'mail', href: 'mailto:ning.chin03@gmail.com' }
];