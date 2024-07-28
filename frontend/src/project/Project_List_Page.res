@react.component
let default = () => {
  let (projects, setProjects) = React.useState(() => Util.Fetch.Response.NotStarted)
  let auth = ReactOidcContext.useAuth()
  let router = Next.Navigation.useRouter()
  let smDown = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smDown)

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

  let onSelectProject = index => {
    projects->Util.Fetch.Response.forSuccess(projects =>
      projects
      ->Array.get(index)
      ->Option.forEach(project => Store.dispatch(StoreSelectedProjectForManagement(project)))
    )
    router->Route.FrontEnd.push(~route=#"/manage/projectAdd")
  }

  <>
    {switch projects {
    | NotStarted => Jsx.null
    | Pending => <Mui.Skeleton />
    | Ok(projects) =>
      <>
        <Mui.List
          component={Mui.OverridableComponent.componentWithUnknownProps(component =>
            if smDown {
              <Mui.Box {...component} />
            } else {
              <Mui.Box
                {...component}
                display={String("grid")}
                gridAutoRows={String("max-content")}
                gridTemplateColumns={String("1fr 1fr")}
                alignItems={String("baseline")}
              />
            }
          )}>
          {projects
          ->Array.mapWithIndex(({name, active}, index) =>
            <Mui.ListItemButton
              key={`project-${index->Int.toString}`}
              divider=true
              onClick={_ => onSelectProject(index)}>
              <Mui.ListItemIcon> {Project_Util.getStateIcon(~active)} </Mui.ListItemIcon>
              <Mui.ListItemText primary={name->Jsx.string} />
              <Icon.ArrowForwardIos />
            </Mui.ListItemButton>
          )
          ->Jsx.array}
        </Mui.List>
        <AddButton onClick=onAddProject />
      </>
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
