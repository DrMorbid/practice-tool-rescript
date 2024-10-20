module Classes = {
  let listSmUp = Mui.Sx.obj({alignItems: Unset})
}

module ListWrapper = {
  @react.component
  let make = (~children) => {
    let smDown = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smDown)

    <Page
      alignContent={Start}
      spaceOnTop=true
      spaceOnBottom=true
      justifyItems="stretch"
      sx={App_Theme.Classes.itemGaps}>
      <PageHeader message=Message.Project.projects />
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
    </Page>
  }
}

@react.component
let default = () => {
  let (projects, setProjects) = React.useState(() => Util.Fetch.Response.NotStarted)
  let auth = ReactOidcContext.useAuth()
  let router = Next.Navigation.useRouter()
  let processFinishedSuccessfullyMessage = Store.useStoreWithSelector(({
    ?processFinishedSuccessfullyMessage,
  }) => processFinishedSuccessfullyMessage)

  React.useEffect(() => {
    setProjects(_ => Pending)

    Util.Fetch.fetch(
      Project,
      ~method=Get,
      ~auth,
      ~responseDecoder=Project_Type.projects_decode,
      ~router,
    )
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
    router->Route.FrontEnd.push(~route=ManageProjectDetail)
  }

  let onSelectProject = index => {
    projects->Util.Fetch.Response.forSuccess(projects =>
      projects
      ->Array.toSorted(Project_Util.getOrdering)
      ->Array.get(index)
      ->Option.forEach(project => Store.dispatch(StoreSelectedProjectForManagement(project)))
    )
    router->Route.FrontEnd.push(~route=ManageProjectDetail)
  }

  <>
    <Snackbar
      isOpen={processFinishedSuccessfullyMessage->Option.isSome}
      severity={Success}
      title={Message(Message.Alert.defaultTitleSuccess)}
      body=?{processFinishedSuccessfullyMessage}
      autoHideDuration=5_000
      onClose={() => Store.dispatch(ResetProcessFinishedSuccessfullyMessage)}
    />
    {switch projects {
    | NotStarted => Jsx.null
    | Pending =>
      <ListWrapper>
        <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
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
        title={Message(Message.Project.couldNotLoadProject)}
        body={String(message)}
      />
    }}
  </>
}
