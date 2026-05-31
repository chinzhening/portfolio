#import "blog/lib.typ": *

#show: article.with(
  title: "First Post",
  desc: [Setting up the blog and writing the first post.],
  published: datetime(year: 2026, month: 5, day: 31),
  tags: (
    "dev-log",
    "typst",
    "svelte",
  ),
)

Hello, I will be using this blog to share my thoughts, experiments, and projects. Let's start with a simple introduction to the blog itself.

This blog is built using SvelteKit, which is a framework for web-apps. I am using `static-adapter` to generate a static site which you are reading right now. There is no particular reason for choosing #link("https://svelte.dev")[Svelte] over other frameworks, it was simply a learning opportunity and I took it. Like most static site generated blogs, the content is authored in a structured text format like #link("https://typst.app")[Typst] and then transformed into HTML for the web. I chose Typst because I like writing in it, it has lovely syntax, and has some experimental support for generating HTML output.

/// Flesh out
I am not the first person to write a blog using Typst, and I want to acknowledge a few projects and communities that inspired this site. In particular, Myriad Dreamin's typst blog template (#link("https://github.com/Myriad-Dreamin/tylant")[tylant]) provided useful ideas and examples, and the Typst community at large has produced excellent tooling, examples, and discussion that made experimenting with Typst feasible.

= Workflow
Writing, compiling, and publishing a post on this site is intentionally simple and reproducible. The typical workflow is:

1. Author the post in Typst (`.typ`) using the helpers in `src/lib/content` and `blog/lib.typ`.
2. Compile the Typst source to HTML using the Typst toolchain (the `typ` command or an equivalent export that produces HTML/CSS).
3. Run a small post-processing script (a Node script in `scripts/` in this repo) that:
  - extracts and normalises front-matter metadata (title, description, publish date, tags),
  - injects anchor links for headings and generates a table of contents if needed,
  - applies any HTML cleanups and integrates syntax highlighting (we use #link("https://shiki.style")[Shiki] for code highlighting),
  - copies or transforms assets (images, local resources) to the `static/` or `build/` output as required.
4. Commit the processed HTML (or the original Typst plus the processed outputs, depending on the post) to the repo.
5. The repository is built using the SvelteKit static adapter and deployed to GitHub Pages (either via a GitHub Action or the Pages deployment flow).

#hrule

This pipeline strikes a balance between authoring convenience (write in Typst) and a predictable static site output (HTML optimized for the blog). Keeping the post-processing explicit makes it easy to add features later — for example, image optimization, alternative output formats, or search indexing — without touching the writing workflow.

/// Diagram: content pipeline (Typst -> HTML -> post-process -> build -> deploy)
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import fletcher.shapes: hexagon, house

#let blob(pos, label, tint: white, ..args, width: 24mm) = node(
  pos,
  align(center, text(fill: muted-colors.white, label)),
  width: width,
  fill: tint.darken(60%),
  stroke: 1pt + tint.darken(20%),
  corner-radius: 5pt,
  ..args,
)

#let edge-helper(..args) = edge(
  "-|>",
  stroke: muted-colors.dark-gray,
  ..args,
)

#my-figure(
  caption: [Content pipeline from Typst source to deployed blog. Yes, this diagram was also made in Typst `html.frame` retains the SVG in HTML output.],
)[
  #html.frame[
    #diagram(
      spacing: 8pt,
      cell-size: (14mm, 12mm),
      edge-stroke: 1pt,
      edge-corner-radius: 5pt,
      node-corner-radius: 4pt,
      mark-scale: 70%,

      // --- Column 0: raw inputs ---
      blob((0, 0.5), width: 20mm, [Typst\ #text(size: 0.8em)[\*.typ]], tint: muted-colors.yellow, name: <src>),
      blob((0, 1.5), width: 20mm, [Assets], tint: muted-colors.orange),

      // --- Column 1: processing ---
      blob((2, 0), [HTML\ #text(size: 0.8em)[(typ export)]], tint: muted-colors.orange, name: <html>),
      edge-helper(),
      blob((2, 1), [Codeblock\ #text(size: 0.8em)[`id` injection]], tint: muted-colors.red),
      edge-helper(),
      blob((2, 2), [Syntax\ highlighting], tint: muted-colors.green, name: <highlight>),
      blob((3, 2), width: 20mm, text(0.8em)[Static article], tint: muted-colors.gray, name: <article>),
      edge(<highlight>, <article>, "-|>", stroke: muted-colors.dark-gray),

      // --- Column 2: output ---
      
      blob((3, 1), [SvelteKit\ #text(size: 0.8em)[(static-adapter)]], tint: muted-colors.blue, name: <sveltekit>),
      blob((5, 0.5), text(size: 0.8em)[Static Site], width: 24mm, tint: muted-colors.red, name: <site>),
      blob((5, 1.5), text(size: 0.8em)[GitHub Pages], width: 24mm, tint: muted-colors.purple, name: <gh-pages>),
      edge(<sveltekit>, <site>, "-|>", stroke: muted-colors.dark-gray, `build`),
      edge(<site>, <gh-pages>, "-|>", stroke: muted-colors.dark-gray, `deploy`),

      // --- Front-matter: queried from .typ, feeds into sveltekit ---
      blob((2, -1), [#text(size: 0.8em)[metadata]], width: 24mm, tint: muted-colors.cyan, name: <metadata>),
      edge(<src.north>, <metadata.west>, "-|>", corner: right, stroke: muted-colors.dark-gray, `query`,),
      edge(<src>, <html>, "-|>", stroke: muted-colors.dark-gray, `compile`),
      edge(<metadata.east>, <sveltekit.north>, "-|>", stroke: muted-colors.dark-gray, corner: right),
      edge(<article.north>, <sveltekit.south>, "-|>", stroke: muted-colors.dark-gray),

      // --- Group enclosures ---
      {
        let tint(c) = (stroke: c, fill: rgb(..c.components().slice(0, 3), 30%), inset: 10pt)
        node(
          enclose: ((0, 0.5), (0, 1.5)),
          ..tint(muted-colors.gray),
          name: <raw>,
        )
        node(
          enclose: ((2, 0), (2, 2), (3, 1)),
          ..tint(muted-colors.gray),
          name: <processing>,
        )
        node(
          enclose: ((5, 0.5), (5, 1.5)),
          ..tint(muted-colors.gray),
          name: <output>,
        )
      },

      // --- Inter-group arrows ---
      edge(<raw>, <processing>, "--|>", stroke: muted-colors.dark-gray + 1.5pt),
      edge(<processing>, <output>,"--|>", stroke: muted-colors.dark-gray + 1.5pt),

      node((0, 2.25), text(size: 0.8em, font: font-mono)[raw]),
      node((2.5, 3), text(size: 0.8em, font: font-mono)[processing]),
      node((5, 2.25), text(size: 0.8em, font: font-mono)[output])
    )
  ]
] <pipeline>

The diagram in @pipeline is an example of what typst can do over markdown. Native support for drawing and layout in typst combined with the ability to export to HTML means we can create custom diagrams and visualisations that *integrate seamlessly* with the rest of the content.

#hrule

```typst
// lib.typ
#let my-figure(content, caption: none) = figure(
  caption: caption,
  html.elem("div", attrs: ("class": "diagram-container"))[
    #content
  ]
)

// post.typ
#my-figure(
  caption: [...]
)[
  #html.frame[
    #diagram(
      spacing: 4pt,
      cell-size: (8mm, 16mm),
      ...
    )
  ]
] <pipeline>
// Figures can be referenced.
// The HTML output translates `<label>` to `id="label"` for linking
```
Since HTML output is still experimental in Typst, SVG output from drawing libraries (e.g. `cetz` and `fletcher`) is ignored by default. Wrapping the diagram in `html.frame` preserves the SVG in the output, allowing us to use Typst's drawing capabilities for custom visuals and diagrams.

To handle overflow, we wrap the `html.frame` in a container with `overflow-x: auto` (the `.diagram-container` class in the CSS). These syles live in `src/lib/css/...` and apply to the HTML output generated by Typst. This allows us to ensure that wide diagrams are scrollable on smaller screens without breaking the layout.

```css
.diagram-container {
  width: 100%;
  padding-block: 0.5rem;
  overflow-x: auto;
}
```

This class is injected into the HTML output by using a `html.elem` wrapper in the Typst layer and specifying the attributes as shown in previous code.

#hrule

== Highlighting
Code blocks need a little more work than headings or paragraphs, because Typst cannot simply attach the final highlight classes at the source layer. Instead, the raw code is kept in a hidden script tag during export so the HTML stays clean and the original source can be recovered without extra whitespace or nested spans.

After that, the Node post-process reads the raw blocks, uses `data-lang` or similar metadata to identify the language, and runs Shiki on the server. The highlighted output is cached, then written back into the HTML before SvelteKit builds the static site. That keeps the client bundle small and gives us deterministic, themeable markup.

#hrule

== MathML

Typst's math support is robust, but the MathML output is still a bit rough around the edges#footnote[See this recent #link("https://github.com/typst/typst/pull/7436")[github merge] for more details.]. For now, I export math as MathML where possible, which gives better semantics and accessibility than trying to hack it into HTML + CSS. The CSS layer can then style the MathML elements to fit the blog's design. Granted, this looks okay for most purposes if you know how to avoid the broken cases.

#side-note[
  A very nice equation that describes the flow of heat:
  $
    (partial u ) / (partial t) = alpha (partial^2 u) / (partial x^2)
  $
  where $alpha > 0$ is the thermal diffusivity constant, and $u(x, t)$ is the temperature distribution over space and time.
]

The benefit of using MathML over another SVG or image-based export is that it remains selectable, searchable, and accessible. With some CSS tweaks, the MathML can be styled to fit the blog's aesthetic while still retaining its semantic structure. Though browsers provide some support MathML rendering, you can optionally
use a rendering library like #link("https://www.mathjax.org/")[MathJax] 
to ensure cross-browser consistency and accessibility.

/// Tables and MathML + MathJax
#let expr = $ u(x, t) + integral_0^t f(x, s) dif s minus log p_pi (x|t) $
#my-figure(
  caption: [An example of MathML output from Typst and MathJax-rendered MathML output fsor comparison.],
  my-table(
    columns: 6,
    [Typst -> MathML #expr],
    [Typst -> MathML -> MathJax #expr],
    [],
    [],
    [],
    [],
  )
)



#hrule


= Upcoming Posts
I initially started this blog to document my learning journey with Typst and SvelteKit, so I expect the next few posts to be focused on technical deep-dives into how the site is built, and related topics like static site opimizations. Beyond that, I have a backlog of ideas and projects I want to write about, which will be backdated (in this order):
- Capstone Monte Carlo Methods in Finance
- Simulation Based Inference: Adaptive Networks for Modeling Epidemics
- Portfolio Website: Detailed walkthrough of building my site with SvelteKit and Typst.
- Github Metrics: ???

= Acknowledgements
- Myriad Dreamin — for the `tylant` template and example workflows. A great reference for how to structure Typst content for a blog.
- The Typst community — for documentation, tooling, and helpful examples.