@@directive("'use client';")

@react.component
let make = (~children) => {
  let prefersDarkMode = Mui.Core.useMediaQueryString(App_Theme.darkModeMediaQuery)

  <MuiNext.AppRouterCacheProvider>
    <Mui.ThemeProvider theme={Theme(App_Theme.theme(~prefersDarkMode))}>
      <Mui.CssBaseline />
      <main>
        <App> {children} </App>
      </main>
    </Mui.ThemeProvider>
  </MuiNext.AppRouterCacheProvider>
}
