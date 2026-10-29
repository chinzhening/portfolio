Personal site and blog. I use SvelteKit with `adapter-static` and deployed this
on Cloudflare Pages.

Posts are written in [Typst](https://typst.app) and compiled to HTML at build
time. This is converted into an AST with [tyquire](plugins/tyquire), which
converts a data exposed from through a blog template into an AST which is then
rendered by a Svelte component. The advantage of this approach is the support
for Typst-Svelte interop. I can add animations and other graphical elements as
a separate Svelte component within the Typst document.

A forkable template is available at [chinzhening/tyquire-template](https://github.com/chinzhening/tyquire-template).
