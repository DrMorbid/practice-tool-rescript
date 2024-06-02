@@directive("'use client';")

@react.component
let make = (~children) => {
  <main>
    <App> {children} </App>
  </main>
}
