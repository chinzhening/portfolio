#import "colors.typ": muted-colors
#import "lib.typ": component, is-html

#let fonts = (
  mono: "Iosevka",
)

// Render a short side note inside the article body. HTML gets the
// component marker; PDF gets its own boxed styling, since component()
// no longer opinionates about non-HTML layout.
#let side-note(content) = context {
  if is-html() {
    component("side-note", content)
  } else {
    block(
      inset: 2em,
      stroke: 1pt + muted-colors.dark-yellow.darken(40%),
      fill: muted-colors.dark-yellow.lighten(70%),
      [
        #block(text(
          font: fonts.mono,
          fill: muted-colors.dark-yellow.darken(40%),
          upper("side note")
        ))
        #content
      ]
    )
  }
}

// Single show-rule entry point for the theme. Every PDF-only presentational
// rule lives inside here, so a post applies the theme once via `#show:
// theme` and a new rule added later needs no change in any post.
#let theme(body) = context {
  if is-html() {
    body
  } else {
    // lib.typ's figure-rules no longer opinionates this.
    show figure.caption: it => [
      #strong[#it.supplement #it.counter.display(it.numbering)#it.separator]#it.body
    ]
    body
  }
}
