@@directive("'use client';")

@react.component
let make = (~children) => {
  let prefersDarkMode = Mui.Core.useMediaQueryString(App_Theme.darkModeMediaQuery)

  React.useEffect0(() => {
    Amplify.amplify->Amplify.Configuration.configure({
      auth: {
        cognito: {
          userPoolId: EnvVar.cognitoUserPoolId,
          userPoolClientId: EnvVar.cognitoUserPoolClientId,
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
