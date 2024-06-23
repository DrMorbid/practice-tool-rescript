@@directive("'use client';")

external dictToState: Dict.t<string> => Webapi.Dom.History.state = "%identity"

@react.component
let make = (~children) => {
  let prefersDarkMode = Mui.Core.useMediaQueryString(App_Theme.darkModeMediaQuery)

  let onSigninCallback = _ => {
    Webapi.Dom.window
    ->Webapi.Dom.Window.history
    ->Webapi.Dom.History.replaceState(
      Dict.make()->dictToState,
      Webapi.Dom.document
      ->Webapi.Dom.Document.asHtmlDocument
      ->Option.map(document => document->Webapi.Dom.HtmlDocument.title)
      ->Option.getOr(""),
      Webapi.Dom.window
      ->Webapi.Dom.Window.location
      ->Webapi.Dom.Location.pathname,
    )
  }

  <MuiNext.AppRouterCacheProvider>
    <Mui.ThemeProvider theme={Theme(App_Theme.theme(~prefersDarkMode))}>
      <Mui.CssBaseline />
      <ReactOidcContext.AuthProvider
        authority="https://cognito-idp.eu-central-1.amazonaws.com/eu-central-1_NWWCPvxRL"
        client_id="5l72lsb5di0lrft25llng18vl0"
        redirect_uri="http://localhost:3000/signIn/redirect"
        scope="openid profile email"
        onSigninCallback>
        <main>
          <App> {children} </App>
        </main>
      </ReactOidcContext.AuthProvider>
    </Mui.ThemeProvider>
  </MuiNext.AppRouterCacheProvider>
}
