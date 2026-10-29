#import "blog/lib.typ": *
#import "blog/theme.typ": *

#show: theme
#show: article.with(
  title: "tyquire",
  desc: [Lessons from redesigning the blog content pipeline.],
  published: true,
  publish_date: datetime(year: 2026, month: 9, day: 8),
  edited_date: datetime(year: 2026, month: 10, day: 29),
  tags: (
    "dev-log",
    "typst",
    "svelte",
    "vite",
  ),
)


The #link("yet-another-typst-blog")[first post] about the blog outlined three issues with the
content pipeline:
#enum(
  numbering: "1.",
  [
    Target-specific markup contaminates the content, coupling the content
    representation to the desired HTML output.
  ],
  [
    Parser correctness: use a tree model rather than a serial model.
  ],
  [
    Extending the output vocabulary propagates changes through every stage of
    the pipeline, making the system difficult to evolve and regression-test.
  ]
)

Since then, the pipeline has been repackaged as `tyquire`#footnote[`tyquire` is short for Typst and 'quire', which
is a word for assembling sheets of paper into a book.], a Vite plugin that
annotates the Typst HTML export as a typed component tree that is rendered with Svelte snippets. The rewrite was
mostly completed with the help of AI as I had a clear idea of the scope early on.

```
.
├── plugins/tyquire/svelte/
│   └── TypstRenderer.svelte      
└── src/lib/
    ├── components/
    │   ├── components.ts         # component registry
    │   ├── SideNoteBlock.svelte  # defines `side-note` component rendering
    │   ├── CodeBlock.svelte
    │   └── ...
    └── content/
        ├── blog/
        │   ├── lib.typ           # html helpers
        │   ├── theme.typ         # defines `side-note` as a component
        │   └── colors.typ
        ├── first-post.typ        # consumes `side-note` and other helpers
        └── second-post.typ
```

= Decoupling the Content and Output Target

Typst exposes `target()`, a _contextual_ function that returns `"html"` under the
`--format html --features html` flags. The fix branches component defined in
`lib.typ` and `theme.typ` on the target once at evaluation.

```typst
// lib.typ
#let is-html() = target() == "html"
```

The #link("https://typst.app/docs/reference/foundations/target/")[target function]
must be evaluated within a `context` because the target output may vary within a single
document. Using this helper, a component like `callout` can define the target
specific render:

```typst
// something like this
#let callout(content) = context {
  if is-html() {
    component("side-note", content)
  } else {
    /* PDF/SVG styling */
    ...
  }
}
```

Separating target-specific markup creates a clearer *producer-consumer boundary*.
The content pipeline consumes a target-agnostic representation, while individual
output targets decide how that representation is rendered. This also  preserves 
the native Typst tooling experience: Tinymist can lint without complaining about
`#html.frame` litter in the source and generate real-time `svg` preview, while
the same source can still be consumed by the HTML exporter for the pipeline.
More importantly, the payoff is that the _authoring environment  and output 
pipeline can evolve independently_.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let fileblob(pos, label, tint: white, w: 25mm, ..args) = node(
  pos,
  align(center, text(fill: muted-colors.white, size: 0.75em, font: fonts.mono, label)),
  width: w,
  fill: tint.darken(60%),
  stroke: 1pt + tint.darken(20%),
  corner-radius: 5pt,
  ..args,
)

#let edge-label(body) = text(size: 0.7em, font: fonts.mono, fill: muted-colors.dark-gray, body)

#let need(pos, label) = node(pos, box(width: 30mm, align(left, edge-label(label))))

#figure(
  caption: [
    Single source, multiple targets
    ],
)[
  #diagram(
    spacing: 10pt,
    edge-stroke: 1pt,
    mark-scale: 70%,

    fileblob((0, 0), "*.typ source", w: 22mm, tint: muted-colors.cyan, name: <src>),
    fileblob((1, -1.4), "tinymist preview", w: 18mm, tint: muted-colors.gray, name: <tinymist>),
    fileblob((1, 1.4), "html export", w: 18mm, tint: muted-colors.green, name: <html>),
    fileblob((1, 0.0), "pdf/svg export", w: 18mm, tint: muted-colors.gray, name: <pdf>),
    edge(<src>, <tinymist>, "-|>", stroke: muted-colors.dark-gray),
    edge(<src>, <html>, "-|>", stroke: muted-colors.dark-gray),
    edge(<src>, <pdf>, "-|>", stroke: muted-colors.dark-gray),

    fileblob((1.8, 1.4), "IR AST", w: 18mm, tint: muted-colors.yellow, name: <pipe>),
    edge(<html>, <pipe>, "-|>", stroke: muted-colors.dark-gray),

    fileblob((2.7, 1.4), "svelte", w: 18mm, tint: muted-colors.red, name: <svelte>),
    edge(<pipe>, <svelte>, "-|>", stroke: muted-colors.dark-gray),

    need((1.9, 2.0), [tyquire-pipeline]),
    need((2.0, -1.7), [typst-tooling]),
    need((2.0, -1.25), [authoring-environment])

  )
] <producer-consumer>

= Parser Correctness

The old parser only walks the direct children of `<body>`, representing each as
a leaf carrying an HTML string. This serial model was convenient but lazy, 
discarding the hierarchical structure present in the HTML export and treating
each subtree as an opaque blob. This is not expressible in the old model.

#figure(
  caption: [
    What the parser produces now
    ],
)[
  #diagram(
    spacing: 10pt,
    edge-stroke: 1pt,
    mark-scale: 70%,

    fileblob((1.5, 0), "callout", w: 22mm, tint: muted-colors.cyan, name: <sn>),
    fileblob((0.1, 1.4), "html", w: 18mm, tint: muted-colors.gray, name: <a>),
    fileblob((1.5, 1.4), "code", w: 18mm, tint: muted-colors.green, name: <b>),
    fileblob((2.9, 1.4), "html", w: 18mm, tint: muted-colors.gray, name: <c>),
    edge(<sn>, <a>, "-|>", stroke: muted-colors.dark-gray),
    edge(<sn>, <b>, "-|>", stroke: muted-colors.dark-gray),
    edge(<sn>, <c>, "-|>", stroke: muted-colors.dark-gray),

    fileblob((2.4, -1.4), "doc", w: 24mm, tint: muted-colors.yellow, name: <d>),
    fileblob((3.4, 0), "figure", w: 22mm, tint: muted-colors.red, name: <fig>),
    edge(<d>, <sn>, "-|>", stroke: muted-colors.dark-gray),
    edge(<d>, <fig>, "-|>", stroke: muted-colors.dark-gray),
  )
] <nesting-after>

The new parser recursively builds a tree model. This not only matches the structure of HTML export, but also allows the pipeline to operate on components at every level. Components can be resolved in the context of their parents and children, and components can themselves contain further components.

To do this, components are marked in Typst with metadata identifying them
as pipeline components. This metadata survives HTML export, providing the parser
with the information it needs to decide where the opaque HTML ends and the
structured IR begins. A subtree is therefore only traversed if a `component()` or
`inline-component()` marker is reachable somewhere beneath it; otherwise, the
entire subtree is retained as an opaque HTML string. 

= Open vocabulary

To open up the vocabulary, the parser recognises components by their shape and
not by their names. Then the name and props are then passed to the renderer.

#figure(
  caption: [Before: six touch points across three layers. After: two touch points, both leave the plugin untouched.],
)[
  #diagram(
    spacing: 10pt,
    edge-stroke: 1pt,
    mark-scale: 65%,

    node((-1.2, -0.75), edge-label[typst]),
    node((-1.2, 0.85), edge-label[plugin]),
    node((-1.2, 2.6), edge-label[app]),

    fileblob((0, -0.75), "lib.typ", tint: muted-colors.orange, name: <lib>),
    fileblob((0, 0.85), "constants.ts parse.ts", tint: muted-colors.red, name: <parse>),
    fileblob((0, 2.15), "types.ts", tint: muted-colors.blue, name: <types>),
    fileblob((0, 2.8), "+page.svelte", tint: muted-colors.blue, name: <route>),
    fileblob((0, 3.6), "MyBlock.svelte", tint: muted-colors.blue, name: <comp>),

    need((1.7, -0.75), [emit the marker]),
    need((1.7, 0.85), [a selector, a branch, a factory]),
    need((1.7, 2.15), [an interface, a union arm]),
    need((1.7, 2.8), [a branch]),
    need((1.7, 3.6), [a new file]),

    edge((0, -0.75), (1.7, -0.75), "-->", stroke: muted-colors.yellow),
    edge((0, 0.85), (1.7, 0.85), "-->", stroke: muted-colors.yellow),
    edge((0, 2.15), (1.7, 2.15), "-->", stroke: muted-colors.yellow),
    edge((0, 2.8), (1.7, 2.8), "-->", stroke: muted-colors.yellow),
    edge((0, 3.6), (1.7, 3.6), "-->", stroke: muted-colors.yellow),

    // After
    fileblob((2.9, -0.75), "theme.typ", tint: muted-colors.orange, name: <lib>),
    fileblob((2.9, 2.3), "components.ts MyBlock.svelte", tint: muted-colors.blue, name: <comp>),

    need((4.6, -0.75), [component def + show rule]),
    need((4.6, 2.3), [one map entry, one component]),

    edge((2.9, -0.75), (4.6, -0.75), "-->", stroke: muted-colors.yellow),
    edge((2.9, 2.3), (4.6, 2.3), "-->", stroke: muted-colors.yellow),

    need((0.45, -1.75), [BEFORE]),
    need((3.35, -1.75), [AFTER]),
  )
] <vocabulary-diagram>


`component()` and `inline-component()` form the protocol. They wrap a construct
in an element carrying `data-typst-node` and a JSON representation of its named
arguments. The parser understands this protocol without knowing the component
vocabulary; the application resolves the resulting name against its component 
registry.

```typst
// theme.typ
#let callout(kind, body) = component(
  "callout",
  body,
  paged: content => { // fallback for PDF/SVG export
    // some styling
    block(content)
  },
  kind: kind
)
```

```typescript
// components.ts
export const components: Record<string, Component<TypstComponentProps>> = {
    code: CodeBlock,
    callout: Callout
    // one more line here, plus the component, is the entire cost of `callout`
};
```

Six touch points collapse to two: define a component and register a renderer. 
`parse.ts` never learns that callout exists, and adding it requires no changes to 
the plugin. An unregistered component simply renders its children, so extending 
the vocabulary is additive rather than a pipeline-wide change.

= Other engineering notes

A few smaller design decisions came out of the implementation.

1. The renderer needed one indirection for Typst's named slots. Typst authors can choose slot names dynamically, while Svelte snippet props must be statically named. Rather than trying to manufacture a snippet prop for every possible slot, every component receives a single `renderNodes` snippet and uses it to render whichever slot it needs. The slot name remains data in the IR.

2. Presentation is similarly kept out of the component protocol. `component()` only marks content for the HTML pipeline; it does not decide how that content looks. Both HTML and PDF presentation remain the responsibility of `theme.typ`. An early implementation violated this boundary by putting PDF styling in `component()` itself, which was a useful reminder that architectural rules need to be checked against the implementation, not merely stated.

3. Vite also exposed a boundary between its module graph and Typst's. Changes to shared `.typ` dependencies are invisible to Vite's normal dependency tracking, so the dependencies reported by Typst are explicitly registered with `addWatchFile()` and fed back through `hotUpdate()`. Similarly, lifecycle-owned state such as the syntax highlighter belongs to the plugin or transform closure rather than module scope, where it can outlive the Vite environment that owns it.

4. Finally, the Typst prelude remains in the repository rather than becoming a published package. This is primarily a tooling decision: keeping `theme.typ`, `lib.typ`, and `colors.typ` in the working tree gives tinymist visibility into the helpers they provide. The plugin itself is structurally capable of standing alone, but publishing it is deliberately deferred until a second real consumer provides evidence for the public API.

= Final Thoughts

The rewrite ultimately makes boundaries more explicit. Typst produces structured 
content, the parser turns it into an IR without knowing the component vocabulary,
and the application decides how those components are rendered.

The same mechanism can support components that have nothing to do with the 
original set of blocks. For example, an interactive animation can be implemented 
as a Svelte component and registered without changes to the parser or the rest of 
the pipeline.

The result is a pipeline that is easier to extend without making each new 
component a change to the pipeline itself.

I am quite pleased with the current state of `tyquire`. If you are interested in
trying it in your own project, a starter template is prepared for you on my
#link("https://github.com/chinzhening/tyquire-template")[GitHub].