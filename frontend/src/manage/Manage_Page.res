@react.component
let default = () => {
  let (projects, setProjects) = React.useState(() => Util.Fetch.Response.NotStarted)
  let auth = ReactOidcContext.useAuth()

  let {dispatch, subscribe, getState} = Store.api
  let unsubscribe = subscribe(state => Console.log2("FKR: from subscription: %s", state))
  dispatch(Increment) // calls subscriptions
  getState()->ignore // 1
  unsubscribe()

  React.useEffect(() => {
    setProjects(_ => Pending)

    Util.Fetch.fetch(#"/project", ~method=Get, ~auth, ~responseDecoder=Project.Type.projects_decode)
    ->Promise.thenResolve(result =>
      switch result {
      | Ok(projects) => setProjects(_ => Ok(projects))
      | Error(error) => setProjects(_ => Error(error))
      }
    )
    ->ignore

    None
  }, [])

  <>
    {switch projects {
    | NotStarted | Ok(_) => Jsx.null
    | Pending => <Mui.Skeleton />
    | Error({message}) =>
      <Snackbar
        isOpen={projects->Util.Fetch.Response.isError}
        severity={Error}
        title={Message(Message.Manage.couldNotLoadProject)}
        body={String(message)}
      />
    }}
  </>
}
