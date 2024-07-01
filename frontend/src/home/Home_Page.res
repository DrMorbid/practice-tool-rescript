module Classes = {
  let container = Mui.Sx.array(
    [ReactDOM.Style.make(~justifyItems="center", ())->MuiStyles.styleToSxArray]->Array.concat(
      App_Theme.Classes.maxHeight,
    ),
  )
}

@react.component
let default = () => {
  let router = Next.Navigation.useRouter()
  let auth = ReactOidcContext.useAuth()
  let intl = ReactIntl.useIntl()

  let routeToSignInPage = _ => router->Route.FrontEnd.push(~route=#"/signIn")

  <Mui.Box
    display={String("grid")}
    gridAutoRows={String("min-content")}
    alignContent={String("space-evenly")}
    sx=Classes.container>
    <Mui.Typography variant={H1} textAlign={Center}>
      {intl->ReactIntl.Intl.formatMessage(Message.Home.welcome)->Jsx.string}
    </Mui.Typography>
    {if auth.isAuthenticated {
      Jsx.null
    } else {
      <Mui.Button variant={Contained} size={Large} onClick=routeToSignInPage>
        {intl->ReactIntl.Intl.formatMessage(Message.Home.signIn)->Jsx.string}
      </Mui.Button>
    }}
  </Mui.Box>
}
