@react.component
let default = () => {
  let router = Next.Navigation.useRouter()
  let auth = ReactOidcContext.useAuth()
  let intl = ReactIntl.useIntl()

  let routeToSignInPage = _ => router->Route.FrontEnd.push(~route=#"/signIn")

  <Page gridAutoRows=String("min-content")>
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
  </Page>
}
