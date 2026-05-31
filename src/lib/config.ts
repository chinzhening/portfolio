import { base } from '$app/paths';

export const name = "Zhe Ning";
export const status = `final year mathematics student @ nus, with an interest in machine learning, ai and software.`;
export const year = 2026;
export const pages: { name: string; href: string }[] = [
    { name: 'Home', href: `${base}/` },
    { name: 'Projects', href: `${base}/projects` },
    { name: 'Posts', href: `${base}/posts` },
    { name: 'Archive', href: `${base}/archive` },
];
export const socials: { name: string; href: string }[] = [
    { name: 'GitHub', href: 'https://github.com/chinzhening' },
    { name: 'LinkedIn', href: 'https://linkedin.com/in/chinzhening' },
    { name: 'mail', href: 'mailto:ning.chin03@gmail.com' }
];