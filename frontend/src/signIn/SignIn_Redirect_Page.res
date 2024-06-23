module Classes = {
  let container = App_Theme.Classes.maxHeight->Mui.Sx.array
}

@react.component
let default = () => {
  let auth = ReactOidcContext.useAuth()
  let router = Next.Navigation.useRouter()

  React.useEffect2(() => {
    if auth.isAuthenticated {
      router->Route.FrontEnd.push(~route=#"/")
    }

    None
  }, (auth, router))

  <Spinner />
}
