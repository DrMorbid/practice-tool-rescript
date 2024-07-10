@react.component
let default = () => {
  let (projects, setProjects) = React.useState(() => Util.Fetch.Response.NotStarted)
  let auth = ReactOidcContext.useAuth()
  let router = Next.Navigation.useRouter()

  React.useEffect(() => {
    setProjects(_ => Pending)

    Util.Fetch.fetch(#"/project", ~method=Get, ~auth, ~responseDecoder=Project_Type.projects_decode)
    ->Promise.thenResolve(result =>
      switch result {
      | Ok(projects) => setProjects(_ => Ok(projects))
      | Error(error) => setProjects(_ => Error(error))
      }
    )
    ->ignore

    None
  }, [])

  let onAddProject = _ => router->Route.FrontEnd.push(~route=#"/manage/projectAdd")

  <>
    {switch projects {
    | NotStarted => Jsx.null
    | Pending => <Mui.Skeleton />
    | Ok(_) => <AddButton onClick=onAddProject />
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
