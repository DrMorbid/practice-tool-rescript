@@directive("'use client';")

module Classes = {
  let container = (~appPadding, isMdUp) => {
    let styles = App_Theme.Classes.maxHeight

    let styles = if isMdUp {
      styles->Array.concat([
        Mui.Sx.Array.obj({marginLeft: String(`${appPadding->Int.toString}px`), width: Unset}),
      ])
    } else {
      styles->Array.concat([
        Mui.Sx.Array.obj({paddingBottom: String(`${appPadding->Int.toString}px`)}),
      ])
    }

    styles->Mui.Sx.array
  }
}

@react.component
let make = (~appPadding, ~children) => {
  let isMdUp = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.mdUp)

  <Mui.Container maxWidth={False} sx={Classes.container(isMdUp, ~appPadding)}>
    {children}
  </Mui.Container>
}
