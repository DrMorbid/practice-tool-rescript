module Classes = {
  let container = App_Theme.Classes.maxHeight->Mui.Sx.array
}

@react.component
let default = () => {
  let auth = ReactOidcContext.useAuth()
  let router = Next.Navigation.useRouter()

  React.useEffect2(() => {
    if auth.isAuthenticated {
      switch Util.LocalStorage.getLastVisitedUrl() {
      | Some(lastVisitedUrl) => {
          Util.LocalStorage.removeLastVisitedUrl()
          router->Next.Navigation.Router.push(lastVisitedUrl)
        }
      | None => router->Route.FrontEnd.push(~route=Home)
      }
    }

    None
  }, (auth, router))

  <Spinner />
}
