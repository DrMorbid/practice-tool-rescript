@react.component
let default = () => {
  let auth = ReactOidcContext.useAuth()

  React.useEffect0(() => {
    auth->ReactOidcContext.Auth.signinRedirect()

    None
  })

  Jsx.null
}
