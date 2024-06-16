@@directive("'use client';")

@react.component
let make = (~children) => {
  <Mui.Container> children </Mui.Container>
}
