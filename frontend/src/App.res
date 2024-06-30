@@directive("'use client';")

module Classes = {
  let container = bottomBarHeight =>
    App_Theme.Classes.maxHeight
    ->Array.concat([
      Mui.Sx.Array.obj({paddingBottom: String(`${bottomBarHeight->Int.toString}px`)}),
    ])
    ->Mui.Sx.array
}

@react.component
let make = (~bottomBarHeight, ~children) => {
  <Mui.Container sx={Classes.container(bottomBarHeight)}> {children} </Mui.Container>
}
