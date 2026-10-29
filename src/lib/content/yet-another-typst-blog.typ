#import "blog/lib.typ": *
#import "blog/theme.typ": *

#show: theme
#show: article.with(
  title: "Yet another Typst blog",
  desc: [Making a blog with Typst and Svelte],
  published: true,
  publish_date: datetime(year: 2026, month: 8, day: 14),
  edited_date: datetime(year: 2026, month: 10, day: 29),
  tags: (
    "dev-log",
    "typst",
    "svelte",
  ),
)

Hello, welcome to my blog.

I built it with #link("https://typst.app")[Typst] and #link("https://svelte.dev")[Svelte].

Like most static sites, the content is authored in a structured text format such as Markdown and then transformed into HTML. I chose Typst instead because it
is more enjoyable to write in and more expressive than Markdown.  I use it for all my technical writing and wanted to see if it can be used for a blog too.

The goal of the project was two-fold:
1. Author content in Typst and have it render in the browser as HTML.
2. Keep the authoring experience as close to Typst as possible. 

Currently, Typst still exposes HTML export as an experimental feature, but as of #link("https://www.typst.app/docs/changelog/0.15.0/")[v0.15.0], this feature includes MathML export out-of-the-box, which is supported by most modern browsers. Previously, the _primary_ way to preserve math in the HTML export was to wrap it in a `html.frame` which outputs an SVG#footnote[This is a well-known hack in the Typst community documented in #link("https://github.com/typst/typst/issues/721#issuecomment-2817103073")[this issue comment].]. Given that this is a technical blog, displaying math that is readable in the source and aesthetic in the browser is high priority.

I am definitely not the first person to write a blog using Typst. So here are the resources and people that inspired this project:
- Myriad Dreamin's template (#link("https://github.com/Myriad-Dreamin/tylant")[tylant]) for static blogs with Astro and Typst which provided useful ideas and examples.
- The #link("https://github.com/OverflowCat/astro-typst")[astro-typst] integration.
- The Typst community that has been producing excellent tooling and discussion that has made this feasible.

= Workflow
Authoring and publishing a post follows the following steps.
1. Write the post in Typst. A `.typ` file is made a source module in the SvelteKit project.
2. When Vite resolves an import of one, the plugin intercepts it and shells out to the `typst` cli, twice in parallel. One invocation compiles the body to HTML over stdin; the other queries the front-matter `<metadata>` label for the post header.
3. Postprocessing is completed on the HTML via Cheerio, which normalises the MathML delimiters, matches and collects raw-source sidecars into a label map then walks node by node into a typed `PostBlock[]`. Shiki highlights code blocks on this walk.
4. Finally, the plugin returns a JavaScript module exporting `{metadata, blocks}` which the post route imports like any other module.
5. `+page.svelte` maps each block type to a defined Svelte component, which is rendered a second time at build time to produce the final static HTML output.

#hrule()

Keeping the post-processing explicit rather than hiding it behind a general purpose renderer makes it cheap to add features later, such as image optimization or search indexing, without touching the writing workflow.

// Diagram: content pipeline
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let blob(pos, label, tint: white, ..args) = node(
  pos,
  align(center, text(fill: muted-colors.white, size: 0.8em, label)),
  width: 26mm,
  fill: tint.darken(60%),
  stroke: 1pt + tint.darken(20%),
  corner-radius: 5pt,
  ..args,
)

#let edge-label(body) = text(size: 0.7em, font: fonts.mono, fill: muted-colors.dark-gray, body)

#figure(
  caption: [The pipeline, from Typst source to static site. This diagram was drawn
    in Typst too: `html.frame` is what keeps the SVG alive in the HTML export.],
)[
  #let dist = 1.5
  #diagram(
    spacing: 10pt,
    edge-stroke: 1pt,
    mark-scale: 70%,

    blob((0, 0), text(font: fonts.mono, size: 0.8em)[\*.typ], tint: muted-colors.yellow),
    edge("-|>", stroke: muted-colors.dark-gray, edge-label[typst]),
    blob((0, dist), [HTML\ + metadata], tint: muted-colors.orange),
    edge("-|>", stroke: muted-colors.dark-gray, edge-label[cheerio]),
    blob((0, 2 * dist), text(font: fonts.mono, size: 0.8em)[PostBlock[]], tint: muted-colors.green),
    edge("-|>", stroke: muted-colors.dark-gray, edge-label[svelte]),
    blob((0, 3 * dist), [Static site], tint: muted-colors.blue),
  )
] <pipeline>

The diagram in @pipeline is the same `html.frame` hack from the introduction, put to a different use. There it was preserving math; here it preserves the SVG that drawing libraries like `cetz` and `fletcher` produce, which the export would otherwise drop. Wrapping it in a `#figure` also gives it a label, and the HTML export turns that `<label>` into an `id`, so the figure can be cross-referenced.

Wide diagrams need to scroll rather than break the layout, and that does not happen in the Typst layer. The plugin lifts each top-level `figure` out of the HTML into a `figure` block, and `FigureBlock.svelte` renders it inside a frame that carries `overflow-x: auto`. The rule lives in `src/lib/css/article.css`, which is imported by the post route alone and scoped under a single class, so it cannot leak across the site.

== Highlighting
Code blocks need more care than headings or paragraphs, because the source has to survive the export before anything can highlight it. Previously, I stored this in a sidecar: the pipeline replaced each rendered fence with an empty `pre`, emitted the raw text separately into a hidden `script` tagged with a matching label, and the parser paired the two back up.

Now Typst's HTML export preserves the source of a block fence, indentation and all, and tags the element with `data-lang` unprompted. The parser now reads the text straight off the `code` element and hands it to Shiki with the language beside it. Tabs are the only casualty, since the export expands them to spaces according to `raw`'s tab size.

The highlighting is executed at build time so the browser gets finished markup. In the UI the code sits in a bordered card with the language label and a copy button that appears on hover; clicking it briefly swaps the icon to a tick before fading away again. The markup stays deterministic and themeable, and the interaction does not incur a runtime penalty.

== MathML
Typst v0.15.0 exports math as MathML, supported by most browsers with built in semantics and accessibility features. Writing
```typst
$ (partial u) / (partial t) = alpha (partial^2 u) / (partial x^2) $
```
in the source gives you

$
  (partial u ) / (partial t) = alpha (partial^2 u) / (partial x^2)
$
in the browser: the PDE that describes the flow of heat, where $alpha > 0$ is the thermal diffusivity constant, and $u(x, t)$ is the temperature distribution over space and time.

#callout()[
  For an infinite rod with initial condition $u(x, 0) = f(x)$, the solution is $f$
  convolved with the *heat kernel*:

  $
    u(x, t) = integral_(-oo)^(oo) f(y) Phi(x - y, t) dif y,
    quad Phi(x, t) = 1 / sqrt(4 pi alpha t) exp(-x^2 \/ 4 alpha t)
  $

  which is a good stress test for the export: an integral with limits, a fraction
  under a root, and an exponential with a nested fraction in its argument.
]

This is the main benefit of using MathML over another SVG or image-based export.
The markup carries semantics, a screen reader can walk it, and with some CSS it can be styled to match the rest of the page.

The tradeoff is that MathML support is uneven across browsers. Chromium has a long-standing issue with MathML rendering of inline stretchy delimiters#footnote[See the Chromium #link("https://issues.chromium.org/issues/40256468")[issue].]. You can ship a rendering library such as #link("https://www.mathjax.org/")[MathJax] and it will handle the rendering for you. 

=== Alignment

Aligned equations are not supported yet due to an upstream bug in the HTML export.

= How the layers are coupled
Typst emits a marker, the parser matches that marker
as a string, and Svelte maps the resulting block type to a component.

```typst
// lib.typ
#let side-note(content) = html.elem(
  "div", attrs: (class: "side-note"), html.elem("p", content)
)
```

The parser looks for exactly `side-note` on a top-level node, tags the block
`type: "side-note"`, and the route renders `<SideNote>`. This means that the Typst markup, the HTML parser, and the associated Svelte component are all coupled together.

= Limitations

== The same source cannot target both PDF and HTML.
Typst's primary use case is still PDF authoring, and writing for the web currently requires reaching for `#html.frame` and `#figure` to keep an SVG alive. That is a hack sitting in the content layer, where it does not belong. Authoring in the source should be compatible with both PDF and HTML export.

- Typst exposes a `target()` function that allows the source to branch on the export target: `"html"` under `--features html`. The helper layer should branch on that, so the author never has to.

== The block model does not nest
This project started out as an MVP that worked for the simplest case: a flat list of blocks. The parser walks only the direct children of the `<body>`, and every block carries a string of HTML rather than child blocks.

#let fileblob(pos, label, tint: white, w: 34mm, ..args) = node(
  pos,
  align(center, text(fill: muted-colors.white, size: 0.75em, font: fonts.mono, label)),
  width: w,
  fill: tint.darken(60%),
  stroke: 1pt + tint.darken(20%),
  corner-radius: 5pt,
  ..args,
)

#figure(
  caption: [What the parser produces today, and what it would need to produce for a
    callout to contain a code block.],
)[
  #diagram(
    spacing: 10pt,
    edge-stroke: 1pt,
    mark-scale: 70%,

    fileblob((0, 0), "html", w: 20mm, tint: muted-colors.gray),
    fileblob((1, 0), "code", w: 20mm, tint: muted-colors.green),
    fileblob((2, 0), "side-note", w: 20mm, tint: muted-colors.cyan),
    fileblob((3, 0), "html", w: 20mm, tint: muted-colors.gray),
    node((1.5, 0.7), edge-label[today: a flat list]),

    fileblob((1.5, 1.8), "side-note", w: 20mm, tint: muted-colors.cyan, name: <sn>),
    fileblob((0.5, 3.2), "p", w: 20mm, tint: muted-colors.gray, name: <a>),
    fileblob((1.5, 3.2), "code", w: 20mm, tint: muted-colors.green, name: <b>),
    fileblob((2.5, 3.2), "p", w: 20mm, tint: muted-colors.gray, name: <c>),
    edge(<sn>, <a>, "-|>", stroke: muted-colors.dark-gray),
    edge(<sn>, <b>, "-|>", stroke: muted-colors.dark-gray),
    edge(<sn>, <c>, "-|>", stroke: muted-colors.dark-gray),
    node((1.5, 3.9), edge-label[wanted: a tree]),
  )
] <nesting>

The parser should be recursive so that it walks into a block's children, but that is a lot of churn and is blocked by a properly designed component surface first.

== Closed Vocabulary
Adding one new block type is not one edit, it is six. The marker has to be emitted from `lib.typ`; sometimes registered as a selector in `constants.ts`; given a branch and a factory in `parse.ts`; declared as an interface and added to the `PostBlock` union in `types.ts`; given a branch in the route; and finally written as a component of its own.

#let need(pos, label) = node(pos, box(width: 40mm, align(left, edge-label(label))))

#figure(
  caption: [Grey arrows are real imports. What a single new block type demands of each
    file is on the right. Note that `lib.typ` has no import edge at all: it is joined
    to the rest by a string and nothing else.],
)[
  #diagram(
    spacing: 12pt,
    edge-stroke: 1pt,
    mark-scale: 70%,

    // --- Layer labels, left ---
    node((-1.2, -1), edge-label[typst]),
    node((-1.2, 0.75), edge-label[plugin]),
    node((-1.2, 3), edge-label[app]),

    // --- Files, centre ---
    fileblob((0, -0.75), "lib.typ", tint: muted-colors.orange, name: <lib>),
    fileblob((0, 1), "constants.ts", tint: muted-colors.red, name: <consts>),
    fileblob((0, 2), "parse.ts", tint: muted-colors.red, name: <parse>),
    fileblob((0, 3.25), "types.ts", tint: muted-colors.blue, name: <types>),
    fileblob((0, 4), "+page.svelte", tint: muted-colors.blue, name: <route>),
    fileblob((0, 5), "MyBlock.svelte", tint: muted-colors.blue, name: <comp>),

    // --- Real imports ---
    edge(<parse>, <consts>, "-|>", stroke: muted-colors.dark-gray),
    edge(<parse>, <types>, "-|>", stroke: muted-colors.dark-gray),
    edge(<route>, <types>, "-|>", stroke: muted-colors.dark-gray),
    edge(<route>, <comp>, "-|>", stroke: muted-colors.dark-gray),

    // --- What one new block type needs, right ---
    need((1.9, -0.75), [emit the marker]),
    need((1.9, 1), [a selector, sometimes]),
    need((1.9, 2), [a branch and a factory]),
    need((1.9, 3.25), [an interface, and an arm on the `PostBlock` union]),
    need((1.9, 4), [a branch]),
    need((1.9, 5), [a whole new file]),

    edge((0, -0.75), (1.9, -0.75), "-->", stroke: muted-colors.yellow),
    edge((0, 1), (1.9, 1), "-->", stroke: muted-colors.yellow),
    edge((0, 2), (1.9, 2), "-->", stroke: muted-colors.yellow),
    edge((0, 3.25), (1.9, 3.25), "-->", stroke: muted-colors.yellow),
    edge((0, 4), (1.9, 4), "-->", stroke: muted-colors.yellow),
    edge((0, 5), (1.9, 5), "-->", stroke: muted-colors.yellow),

    // --- Layer enclosures ---
    {
      let tint(c) = (stroke: c, fill: rgb(..c.components().slice(0, 3), 30%), inset: 8pt)
      node(enclose: ((0, -0.75),), ..tint(muted-colors.dark-gray), corner-radius: 5pt, stroke: none)
      node(enclose: ((0, 1), (0, 2)), ..tint(muted-colors.dark-gray), corner-radius: 5pt, stroke: none)
      node(enclose: ((0, 3.25), (0, 5)), ..tint(muted-colors.dark-gray), corner-radius: 5pt, stroke: none)
    },
  )
] <vocabulary>

Six touch points for one component is a workable cost for a personal blog with four block types at the moment, but it is a hard lock-in that makes it impossible for others to work with the system without changing the plugin internals.

Underneath all three is the same issue: this is a pipeline written for one site,
with the host application's types reaching into it. What I want instead is an
integration in the shape of #link("https://mdsvex.pngwn.io")[mdsvex] or
`astro-typst`: Typst HTML in, a typed tree out, with the host app supplying the
components and the renderer.

= Upcoming Posts
The #link("tyquire")[next post] rebuilds the pipeline described above into something that could be
used by a site other than this one, and redesigns the authoring interface along the
way. After that I have a backlog of ideas and projects to write about, which will be
backdated:

- Modern Monte Carlo
- Squaredle Solver
- Typst: compiler internals