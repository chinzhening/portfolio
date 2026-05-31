#import "colors.typ": muted-colors

/* 
  This file defines the metadata component for the blog.
  It can be queried by the backend to generate the list of posts and their metadata.
*/
#let generate-metadata(
  title,
  desc,
  published,
  updated,
  tags,
) = {
  if updated != none [ #metadata(
    (title: title,
     desc: desc,
     published: published.display(),
     updated: updated.display(),
     tags: tags
    )
  ) <metadata>]
  else [ #metadata(
    (title: title,
     desc: desc,
     published: published.display(),
     tags: tags
    )
  ) <metadata>]
}

#let side-note(content) = html.elem("div", attrs: (class: "side-note"),
  html.elem("p", content)
)

#let hrule = html.elem(
  "div",
  attrs: ("class": "hrule"),
)[]

#let my-figure(
  content,
  caption: none,
) = figure(
  caption: caption,
  html.elem("div", attrs: ("class": "diagram-container"))[
    #content
  ]
)


#let lang-tab-size = (
  "python": 4,
  "javascript": 2,
  "css": 2,
  "typ": 2,
  "rust": 2,
)

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

#let figure-rules(body) = context {
  show figure.caption: it => context [
      *#it.supplement #it.counter.display(it.numbering)*#it.separator#it.body
  ]
  body
}


/// This file defines the article component for the blog.
#let article(
  content,
  title: "Untitled",
  desc: [This is a blog post.],
  published: none,
  updated: none,
  tags: (),
) = {
  generate-metadata(
    title,
    desc,
    published,
    updated,
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