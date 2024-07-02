@react.component
let default = () => {
  let auth = ReactOidcContext.useAuth()

  React.useEffect(() => {
    Util.Fetch.fetch(#"/project", ~method=Get, ~auth, ~responseDecoder=Project.Type.projects_decode)
    ->Promise.thenResolve(result =>
      switch result {
      | Ok(projects) => Console.log2("FKR: projects=%o", projects)
      | Error(error) => Console.error2("FKR: error=%o", error)
      }
    )
    ->ignore

    None
  }, [])
  <Spinner />
}
