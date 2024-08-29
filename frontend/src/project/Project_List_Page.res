module Classes = {
  let listSmUp = Mui.Sx.obj({alignItems: Unset})
}

module ListWrapper = {
  @react.component
  let make = (~children) => {
    let smDown = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smDown)

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
      )}
      sx=?{if smDown {
        None
      } else {
        Some(Classes.listSmUp)
      }}>
      {children}
    </Mui.List>
  }
}

@react.component
let default = () => {
  let (projects, setProjects) = React.useState(() => Util.Fetch.Response.NotStarted)
  let auth = ReactOidcContext.useAuth()
  let router = Next.Navigation.useRouter()

  React.useEffect(() => {
    setProjects(_ => Pending)

    Util.Fetch.fetch(Project, ~method=Get, ~auth, ~responseDecoder=Project_Type.projects_decode)
    ->Promise.thenResolve(result =>
      switch result {
      | Ok(projects) => setProjects(_ => Ok(projects))
      | Error(error) => setProjects(_ => Error(error))
      }
    )
    ->ignore

    None
  }, [])

  let onAddProject = _ => {
    Store.dispatch(ResetProjectForManagement)
    router->Route.FrontEnd.push(~route=#"/manage/projectDetail")
  }

  let onSelectProject = index => {
    projects->Util.Fetch.Response.forSuccess(projects =>
      projects
      ->Array.toSorted(Project_Util.getOrdering)
      ->Array.get(index)
      ->Option.forEach(project => Store.dispatch(StoreSelectedProjectForManagement(project)))
    )
    router->Route.FrontEnd.push(~route=#"/manage/projectDetail")
  }

  <>
    {switch projects {
    | NotStarted => Jsx.null
    | Pending =>
      <ListWrapper>
        <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
        <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
        <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
      </ListWrapper>
    | Ok(projects) =>
      <>
        <ListWrapper>
          {projects
          ->Array.toSorted(Project_Util.getOrdering)
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
        </ListWrapper>
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
