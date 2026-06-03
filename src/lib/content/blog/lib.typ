#import "colors.typ": muted-colors

#let font-mono = "Iosevka"

/* 
  This file defines the metadata component for the blog.
  It can be queried by the backend to generate the list of posts and their metadata.
*/

// Build the post metadata block used by the content pipeline.
#let generate-metadata(
  title,
  desc,
  published,
  publish_date,
  edited_date,
  tags,
) = {
  if edited_date != none [ #metadata(
    (title: title,
     desc: desc,
     published: published,
     publish_date: publish_date.display(),
     edited_date: edited_date.display(),
     tags: tags
    )
  ) <metadata>]
  else [ #metadata(
    (title: title,
     desc: desc,
     published: published,
     publish_date: publish_date.display(),
     tags: tags
    )
  ) <metadata>]
}

// Render a short side note inside the article body.
#let side-note(content) = html.elem("div", attrs: (class: "side-note"),
  html.elem("p", content)
)

// Insert a simple horizontal rule element.
#let hrule = html.elem(
  "div",
  attrs: ("class": "hrule"),
)[]

#let my-figure(
  content,
  caption: none,
) = figure(
  caption: caption,
  content,
)
#let my-table(
  columns: 1,
  ..content,
) = table(
  columns: columns,
  ..content.map(
    it => html.elem("div", attrs: ("class": "table-cell"), it)
  )
)


// Default tab sizes for supported code languages.
#let lang-tab-size = (
  "python": 4,
  "javascript": 2,
  "css": 2,
  "typ": 2,
  "rust": 2,
)

// Number block code fences and expose their metadata to the HTML output.
#let codeblock-counter = counter("codeblock")
#let codeblock-rules(body) = context {
  show raw.where(block: true): it => {
    codeblock-counter.step()
    let attrs = (
      "data-typst-label": "codeblock-" + codeblock-counter.display(),
      "data-lang": it.lang,
    )
    let elem = html.elem("pre",
      html.elem("code", attrs: attrs, [])
    )
    elem
  }
  body
}

// Format figure captions with the blog's consistent typography.
#let figure-rules(body) = context {
  show figure.caption: it => context [
      *#it.supplement #it.counter.display(it.numbering)*#it.separator#it.body
  ]
  body
}


// Main article wrapper: emits metadata, applies the rules, and renders content.
#let article(
  content,
  title: "Untitled",
  desc: [This is a blog post.],
  published: "false",
  publish_date: none,
  edited_date: none,
  tags: (),
) = {
  generate-metadata(
    title,
    desc,
    published,
    publish_date,
    edited_date,
    tags,
  )

  show: codeblock-rules
  show: figure-rules

  content

  context {
    query(raw.where(block: true))
      .enumerate()
      .map(((idx, it)) => {
        let attrs = (
          "data-typst-label": "codeblock-" + str(idx),
          "type": "text/plain",
        )
        html.elem("script", attrs: attrs, it.text)
      })
      .join()
  }
  
}
