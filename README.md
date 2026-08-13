# svelte-blog

Personal site and blog. SvelteKit with `adapter-static`, deployed to GitHub Pages.

Posts are written in [Typst](https://typst.app), not Markdown, and compiled to
HTML at build time by a Vite plugin in `plugins/`.

## Requirements

- **Node 22 or newer.**
- **The `typst` binary on your `PATH`**, version **0.15.0**, built with HTML
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
