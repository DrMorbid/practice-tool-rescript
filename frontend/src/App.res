@@directive("'use client';")

module Classes = {
  let container = App_Theme.Classes.maxHeight->Mui.Sx.array
}

@react.component
let make = (~children) => {
  <Mui.Container sx=Classes.container> {children} </Mui.Container>
}
