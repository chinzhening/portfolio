/* 
  This file defines the metadata component for the blog.
  It can be queried by the backend to generate the list of posts and their metadata.
*/

#let is-html() = target() == "html"

// Helper function that generates component metadata. Expand on this
#let component(name, body, ..props) = context {
  if is-html() {
    html.elem("div", attrs: (
      "data-typst-node": name,
      "data-typst-props": json.encode(props.named(), pretty: false),
      ), body)
  } else {
    block(
      inset: (left: 1em),
      stroke: (left: 1pt),
      body
    )
  }
}

// Another helper function
#let inline-component(name, body, ..props) = context {
  if is-html() {
    html.elem("span", attrs: (
      "data-typst-node": name,
      "data-typst-props": json.encode(props.named(), pretty: false),
    ), body)
  } else { body }
}

#let slot(name, body) = context {
  if is-html() { html.elem("div", attrs: ("data-typst-slot": name), body) } else { body }
}

// Render a short side note inside the article body.
#let side-note(content) = component("side-note", content)

// Insert a simple horizontal rule element.
#let hrule() = context {
  if is-html() { html.elem("hr") } else { line(length: 100%) }
}

// Format figure captions with the blog's consistent typography.
#let figure-rules(body) = context {
  if is-html() {
    show figure: it => component("figure", {
      it.body
      if it.caption != none {
        slot("caption", [#strong[#it.supplement #context it.counter.display(it.numbering).] #it.caption.body])
      }
    })
    body
  } else { body }
}

// Build the post metadata block used by the content pipeline.
#let generate-metadata(
  title,
  desc,
  published,
  publish_date,
  edited_date,
  tags,
) = {
  if edited_date != none and publish_date != none [ #metadata(
    (title: title,
     desc: desc,
     published: published,
     publish_date: publish_date.display(),
     edited_date: edited_date.display(),
     tags: tags
    )
  ) <metadata>]
  else if publish_date != none [ #metadata(
    (title: title,
     desc: desc,
     published: published,
     publish_date: publish_date.display(),
     tags: tags
    )
  ) <metadata>]
  else [ #metadata(
    (title: title,
     desc: desc,
     published: published,
     tags: tags
    )
  ) <metadata>]
}

// Main article wrapper: emits metadata, applies the rules, and renders content.
#let article(
  content,
  title: "Untitled",
  desc: [This is a blog post.],
  published: false,
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

  show: figure-rules

  content
}
