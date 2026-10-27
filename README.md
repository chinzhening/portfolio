# Portfolio

Personal site and blog. I use SvelteKit with `adapter-static` and deployed this
on Cloudflare Pages.

Posts are written in [Typst](https://typst.app) and compiled to HTML at build
time. This is converted into an AST with [tyquire](plugins/tyquire), which
converts a data exposed from through a blog template into an AST which is then
rendered by a Svelte component. The advantage of this approach is the support
for Typst-Svelte interop. I can add animations and other graphical elements as
a separate Svelte component within the Typst document.

## Requirements

- **Node 22 or newer.**
- **The `typst` binary on your `PATH`**, version **0.15.0+**, built with HTML
  export support. The build shells out to it for every post; without it the
  first `.typ` transform fails.
- **TTF fonts** reachable via the `TYPST_FONT_PATH` environment variable. Typst
  needs them to render text inside SVG figures. The deploy workflow uses
  [Iosevka](https://github.com/be5invis/Iosevka).

## Getting started

```sh
npm ci
npm run dev
```

## Commands

| Command           | Does                            |
| ----------------- | ------------------------------- |
| `npm run dev`     | Start the dev server            |
| `npm run build`   | Build to `build/`               |
| `npm run preview` | Serve the built site            |
| `npm run check`   | `svelte-check`                  |
| `npm run lint`    | `prettier --check` and `eslint` |
| `npm run format`  | `prettier --write`              |

## Writing a post

Add a `.typ` file to `src/lib/content/`. It is picked up automatically and
compiled into typed blocks that `src/routes/posts/[slug]/+page.svelte` renders.
Shared Typst helpers live in `src/lib/content/blog/lib.typ`.

## Notes

`package-lock.json` must be regenerated on Linux. A lock resolved on Windows
records wasm packages whose peer dependencies are missing on Linux, and `npm ci`
then refuses to install it.

## Unsupported features

- interop demonstration
- tyquire README.md
- forkable blog template

Feel free to reach out if you want to use this as a template for your own blog.
I'd be happy to help you with any questions about the setup and deployment.
