#import "blog/lib.typ": *
#import "blog/colors.typ": muted-colors

#let font-mono = "Iosevka"

#show: article.with(
  title: "First Post",
  desc: [Setting up the blog and writing the first post.],
  published: "true",
  publish_date: datetime(year: 2026, month: 8, day: 14), 
  tags: (
    "dev-log",
    "typst",
    "svelte",
  ),
)

Hello, I will be using this blog to share my thoughts, experiments, and projects. Let's start with a simple introduction to the blog itself.

This blog is built on SvelteKit, a framework for web-apps. I use `static-adapter` to generate a static site hosted on GitHub pages. There is no reason for choosing #link("https://svelte.dev")[Svelte] over other frameworks, but the static adapter is easy to set up, and I have experience with Svelte that made it convenient for this project.
Like most static sites, the content is authored in a structured text format such as Markdown and then transformed into HTML for the browser. I chose #link("https://typst.app")[Typst] instead because I like writing in it, it has crisp syntax for mathematics, real scripting, and native support for drawing diagrams.

Currently, Typst still exposes HTML export as an experimental feature, but as of #link("https://www.typst.app/docs/changelog/0.15.0/")[v0.15.0], this feature includes MathML export out-of-the-box, which is supported by most modern browsers. Previously, the _primary_ way to preserve math in the HTML export was to wrap it in a `html.frame` which outputs an SVG#footnote[This is a well-known hack in the Typst community documented in #link("https://github.com/typst/typst/issues/721#issuecomment-2817103073")[this issue comment].]. Given that this is a technical blog, authoring math that is readable in the source and accessible in the browser is high priority.

I am definitely not the first person to write a blog using Typst, or even Typst with Svelte. So here are the acknowledgements to the resources and inspiration that inspired this project:
- Myriad Dreamin's template (#link("https://github.com/Myriad-Dreamin/tylant")[tylant]) for static blogs with Astro and Typst which provided useful ideas and examples.
- The #link("https://github.com/OverflowCat/astro-typst")[astro-typst] integration.
- The Typst community that has been producing excellent tooling and discussion that has made this feasible.

= Workflow
Authoring and publishing a post follows the following steps.
1. Write the post in Typst #sym.dash.em A `.typ` file is made a source module in the SvelteKit project.
2. When Vite resolves an import of one, the plugin intercepts it and shells out to the `typst` cli, twice in parallel. One invocation compiles the body to HTML over stdin; the other queries the front-matter `<metadata>` label for the post header.
3. Postprocessing is completed on the HTML via Cheerio, which normalises the MathML delimiters, matches and collects raw-source sidecars into a label map then walks node by node into a typed `PostBlock[]`. Shiki highlights code blocks on this walk.
4. Finally, the plugin returns a JavaScript module exporting `{metadata, blocks}` which the post route imports like any other module.
5. `+page.svelte` maps each block type to a defined Svelte component, which is rendered a second time at build time to produce the final static HTML output.

#hrule()

Keeping the post-processing explicit rather than hiding it behind a general purpose renderer makes it cheap to add features later, such as image optimization or search indexing, without touching the writing workflow. It has costs too, which the last two sections are about.

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

#let edge-label(body) = text(size: 0.7em, font: font-mono, fill: muted-colors.dark-gray, body)

#figure(
  caption: [The pipeline, from Typst source to static site. This diagram was drawn
    in Typst too: `html.frame` is what keeps the SVG alive in the HTML export.],
)[
  #let dist = 1.5
  #html.frame[
    #diagram(
      spacing: 10pt,
      edge-stroke: 1pt,
      mark-scale: 70%,

      blob((0, 0), [`*.typ`], tint: muted-colors.yellow),
      edge("-|>", stroke: muted-colors.dark-gray, edge-label[typst]),
      blob((0, dist), [HTML\ + metadata], tint: muted-colors.orange),
      edge("-|>", stroke: muted-colors.dark-gray, edge-label[cheerio]),
      blob((0, 2 * dist), [`PostBlock[]`], tint: muted-colors.green),
      edge("-|>", stroke: muted-colors.dark-gray, edge-label[svelte]),
      blob((0, 3 * dist), [Static site], tint: muted-colors.blue),
    )
  ]
] <pipeline>

The diagram in @pipeline is the same `html.frame` hack from the introduction, put to a different use. There it was preserving math; here it preserves the SVG that drawing libraries like `cetz` and `fletcher` produce, which the export would otherwise drop. Wrapping it in a `#figure` also gives it a label, and the HTML export turns that `<label>` into an `id`, so the figure can be cross-referenced like any other.

Wide diagrams need to scroll rather than break the layout, and that does not happen in the Typst layer. The plugin lifts each top-level `figure` out of the HTML into a `figure` block, and `FigureBlock.svelte` renders it inside a frame that carries `overflow-x: auto`. The rule lives in `src/lib/css/article.css`, which is imported by the post route alone and scoped under a single class, so it cannot leak across the site.

#hrule()

== Highlighting
Code blocks need a little more work than headings or paragraphs, because Typst cannot simply attach the final highlight classes at the source layer. The trick is a sidecar. Alongside the rendered `pre` element, the export also emits the raw text of every fence into a hidden `script` tagged with the same label. That keeps the rendered markup clean, and it preserves the exact source without extra whitespace or nested spans to unpick.

The parser collects those sidecars into a label-to-source map and strips them out of the tree. When the walk later reaches a code fence, it reads the language off the element, looks up the original text by label, and hands both to Shiki. Highlighting happens on the server at build time, so the browser gets finished markup and no highlighting library.

In the UI, the code is wrapped in a bordered card with the language label and a copy button that appears on hover; clicking it briefly swaps the icon to a tick before fading away again. The markup stays deterministic and themeable, and the interaction costs nothing on the client.

#hrule()

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

#side-note[
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

The tradeoff is that browser MathML support is uneven, and the usual answer is to ship a rendering library like #link("https://www.mathjax.org/")[MathJax] to duct tape the gaps. I tried that and then removed it because shipping a typesetting engine (roughly a megabyte of JavaScript) to fix a handful of misrendered brackets is a bad trade on a blog that is otherwise entirely static markup. The better fix was to correct the MathML itself, once, at build time.

=== Stretchy delimiters
Typst does not set `stretchy="false"` on delimiters#footnote[See #link("https://github.com/typst/typst/issues/8105")[issue] for details.], so the browser decides for
itself whether a bracket should grow. Chromium tends to grow them even when the
enclosed content is a single line, which makes ordinary parenthesised expressions
look subtly wrong beside their neighbours.

Upstream cannot really fix this in the exporter. The answer in that issue is that at the point where the HTML is emitted, Typst does not have enough information to know whether a delimiter will end up stretched relative to what surrounds it, so it cannot decide the value of the attribute. Post-processing does not have that problem. By then the tree is finished, and whatever sits between a pair of delimiters is right there to be inspected.

So the post-processing step walks each `math` element and pairs opening delimiters with their partners using a depth counter, so nesting is handled correctly. For each pair it checks whether anything genuinely tall is enclosed at any depth: fractions, roots, tables, or over- and under-scripts. If none of them are present, `stretchy="false"` is emitted on the pair and the browser leaves them alone. Attributes that Typst already sets are never overwritten.

=== Alignment
Here is a two-line equation with an alignment point at each `&`:

$
  u(x, t) &= sum_(n=1)^oo b_n e^(-alpha omega_n^2 t) \
  omega_n &= (n pi) \/ L
$

It does survive the export. MathML has no native `align` environment like LaTeX's,
so Typst simulates one with an `mtable`, splitting each line at the `&` into a cell
for the left-hand side and a cell for the operator and everything after it. It even
hands you class names to hook onto:

```html
<math display="block">
  <mtable class="multiline-equation aligned">
    <mtr><mtd>u(x, t)</mtd><mtd><mo form="infix">=</mo> ...</mtd></mtr>
    <mtr><mtd>omega_n</mtd><mtd><mo form="infix">=</mo> ...</mtd></mtr>
  </mtable>
</math>
```

The structure is right, but the typography is not. Nothing sets the column
alignment, and an `mtable` centres every column by default, so instead of the
left-hand sides sitting flush against a shared `=`, each cell floats in the middle
of its column and the equals signs wander. What comes out is a grid, not an
alignment. There is a second, subtler problem in the same equation: the summation
renders with its limits beside the operator rather than above and below it, as though
the whole thing were inline. `sum` carries `movablelimits`, so its limits drop to
script position whenever `displaystyle` is false, and nothing in the exported markup
sets `displaystyle` on the table.

Neither is really a Typst bug, and neither needs one to be fixed. Alignment is pure
presentation, and since `mtd` is a `display: table-cell`, a `text-align` rule against
the `aligned` class sorts it out. `displaystyle` is not a CSS property, so that one
has to be written into the markup by the same post-processing pass that already
handles the delimiters.

#hrule()

= How the layers are coupled
The design rests on one thing: Typst emits a marker, the parser matches that marker
as a string, and Svelte maps the resulting block type to a component.

```typst
// lib.typ
#let side-note(content) = html.elem(
  "div", attrs: (class: "side-note"), html.elem("p", content)
)
```

The parser looks for exactly `side-note` on a top-level node, tags the block
`type: "side-note"`, and the route renders `<SideNote>`. Three layers, coupled by a
string literal, with nothing checking that they agree. Rename the class in one place
and the block silently falls through to generic HTML. It works, and it is legible,
but it is the weak point of the whole arrangement.

= Limitations
Three problems are worth noting because they are what the next post is about.

*The same source cannot target both PDF and HTML.* Typst's primary use case is still PDF authoring, and writing for the web currently requires reaching for `#html.frame` and `#figure` to keep an SVG alive. That is a hack sitting in the content layer, where it does not belong. Authoring in the source should be compatible with both PDF and HTML export.

Typst exposes a `target()` function that allows the source to branch on the export target: `"html"` under `--features html`. The helper layer should branch on that, so the author never has to.

*The block model cannot nest.* This project started out as an MVP that worked for the simplest case: a flat list of blocks. The parser walks only the direct children of the `<body>`, and every block carries a string of HTML rather than child blocks.

#let fileblob(pos, label, tint: white, w: 34mm, ..args) = node(
  pos,
  align(center, text(fill: muted-colors.white, size: 0.75em, font: font-mono, label)),
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
  #html.frame[
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
  ]
] <nesting>

The fix is to make the parser recursive so that it walks into a block's children, but that is a lot of churn and it needs a properly designed block surface first. It also runs straight into the next problem.

*Closed vocabulary.* Adding one new block type is not one edit, it is six. The marker has to be emitted from `lib.typ`; sometimes registered as a selector in `constants.ts`; given a branch and a factory in `parse.ts`; declared as an interface and added to the `PostBlock` union in `types.ts`; given a branch in the route; and finally written as a component of its own.

#let need(pos, label) = node(pos, box(width: 40mm, align(left, edge-label(label))))

#figure(
  caption: [Grey arrows are real imports. What a single new block type demands of each
    file is on the right. Note that `lib.typ` has no import edge at all: it is joined
    to the rest by a string and nothing else.],
)[
  #html.frame[
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
  ]
] <vocabulary>

Six touch points for one component is a workable cost for a personal blog with four block types at the moment, but it is a hard lock-in that makes it impossible for other people to work with the system without forking and editing the source.

#hrule()

Underneath all three is the same issue: this is a pipeline written for one site,
with the host application's types reaching into it. What I want instead is an
integration in the shape of #link("https://mdsvex.pngwn.io")[mdsvex] or
`astro-typst`: Typst HTML in, a typed tree out, with the host app supplying the
components and the renderer. That is the subject of the next post.

= Upcoming Posts
The next post rebuilds the pipeline described above into something that could be
used by a site other than this one, and redesigns the authoring interface along the
way. After that I have a backlog of ideas and projects to write about, which will be
backdated:

- Modern Monte Carlo
- Squaredle Solver