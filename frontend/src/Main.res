@@directive("'use client';")

@react.component
let make = (~children) => {
  let prefersDarkMode = Mui.Core.useMediaQueryString(App_Theme.darkModeMediaQuery)

  React.useEffect0(() => {
    Amplify.amplify->Amplify.Configuration.configure({
      auth: {
        cognito: {
          userPoolClientId: "5l72lsb5di0lrft25llng18vl0",
          userPoolId: "eu-central-1_NWWCPvxRL",
        },
      },
    })

    None
  })

  <MuiNext.AppRouterCacheProvider>
    <Mui.ThemeProvider theme={Theme(App_Theme.theme(~prefersDarkMode))}>
      <Mui.CssBaseline />
      <main>
        <App> {children} </App>
      </main>
    </Mui.ThemeProvider>
  </MuiNext.AppRouterCacheProvider>
}
