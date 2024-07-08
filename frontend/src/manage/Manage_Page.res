module AddProjectDialog = Manage_AddProjectDialog

module Classes = {
  let addButton = bottomBarHeight =>
    Mui.Sx.obj({
      position: String("absolute"),
      bottom: String(`${(bottomBarHeight + 16)->Int.toString}px`),
      right: String("16px"),
    })
}

@react.component
let default = () => {
  let (projects, setProjects) = React.useState(() => Util.Fetch.Response.NotStarted)
  let (addProjectDialogOpen, setAddProjectDialogOpen) = React.useState(() => false)
  let auth = ReactOidcContext.useAuth()
  let bottomBarHeight = Store.useStoreWithSelector(({bottomBarHeight}) => bottomBarHeight)

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

  let onAddProject = _ => setAddProjectDialogOpen(_ => true)

  <>
    <AddProjectDialog
      isOpen=addProjectDialogOpen onClose={() => setAddProjectDialogOpen(_ => false)}
    />
    {switch projects {
    | NotStarted => Jsx.null
    | Pending => <Mui.Skeleton />
    | Ok(_) =>
      <Mui.Fab onClick=onAddProject color=Primary sx={Classes.addButton(bottomBarHeight)}>
        <Icon.AddTwoTone />
      </Mui.Fab>
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
