@@directive("'use client';")

external dictToState: Dict.t<string> => Webapi.Dom.History.state = "%identity"

module Classes = {
  let appBar = Mui.Sx.obj({bottom: Number(0.), top: Unset, left: Number(0.), right: Unset})
}

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
        authority={`${EnvVar.cognitoUrl}/${EnvVar.cognitoUserPoolId}`}
        client_id=EnvVar.cognitoUserPoolClientId
        redirect_uri=EnvVar.cognitoRedirectUrl
        scope="openid profile email"
        onSigninCallback>
        <main>
          <App> {children} </App>
          <Mui.AppBar position={Fixed} sx=Classes.appBar>
            <Mui.BottomNavigation showLabels=true value=0 onChange={(_event, _newValue) => {()}}>
              <Mui.BottomNavigationAction label={"Practice"->Jsx.string} />
              <Mui.BottomNavigationAction label={"Manage"->Jsx.string} />
              <Mui.BottomNavigationAction label={"History"->Jsx.string} />
            </Mui.BottomNavigation>
          </Mui.AppBar>
        </main>
      </ReactOidcContext.AuthProvider>
    </Mui.ThemeProvider>
  </MuiNext.AppRouterCacheProvider>
}
