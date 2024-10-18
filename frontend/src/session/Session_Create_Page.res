open Session_Util

module Form = Session_Create_Page_Form

module Classes = {
  let topPrioInfoGap =
    [
      Mui.Sx.Array.func(theme =>
        ReactDOM.Style.make(
          ~gridColumnGap=theme->MuiSpacingFix.spacing(1),
          (),
        )->MuiStyles.styleToSxArray
      ),
    ]->Mui.Sx.array
  let topPrioInfoSpan = ReactDOM.Style.make(~gridColumnStart="span 2", ())->MuiStyles.styleToSx
}

@react.component
let default = () => {
  let (projects, setProjects) = React.useState(() => Util.Fetch.Response.NotStarted)
  let (selectedProject, setSelectedProject) = React.useState(() => None)
  let form = Form.Content.use(
    ~config={
      defaultValues: Form.Input.defaultValues,
    },
  )
  let auth = ReactOidcContext.useAuth()
  let intl = ReactIntl.useIntl()
  let smUp = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smUp)
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
      | Ok(projects) => setProjects(_ => Ok(projects->Array.filter(({active}) => active)))
      | Error(error) => setProjects(_ => Error(error))
      }
    )
    ->ignore

    None
  }, [])

  React.useEffect(() => {
    projects->resetForm(~form)

    None
  }, [projects])

  let onSubmit = ({projectName, exerciseCount}: Session_Type.t) =>
    router->Route.FrontEnd.push(~route=PracticeOverview(projectName, exerciseCount))

  let onCancel = _ => {
    projects->resetForm(~form)
    setSelectedProject(_ => None)
  }

  let onProjectNameChange = event => {
    let selectedProject =
      projects->findProject(~projectName=(event->ReactEvent.Form.target)["value"])

    selectedProject->Util.Fetch.Response.forSuccess(project => {
      setSelectedProject(_ => project)

      project->setSelectedExerciseCount(~form)
    })
  }

  let getExercisesCount = projects =>
    selectedProject
    ->Option.map(getExerciseCountSelection)
    ->Option.getOr(projects->Array.get(0)->Option.map(getExerciseCountSelection)->Option.getOr([]))

  <>
    <Snackbar
      isOpen={processFinishedSuccessfullyMessage->Option.isSome}
      severity={Success}
      title={Message(Message.Alert.defaultTitleSuccess)}
      body=?{processFinishedSuccessfullyMessage}
      autoHideDuration=5_000
      onClose={() => Store.dispatch(ResetProcessFinishedSuccessfullyMessage)}
    />
    <Snackbar
      isOpen={projects
      ->Util.Fetch.Response.mapSuccess(projects => projects->Array.length == 0)
      ->Util.Fetch.Response.toOption
      ->Option.getOr(false)}
      severity={Warning}
      title={Message(Message.Session.noProjects)}
    />
    <Snackbar
      isOpen={projects
      ->Util.Fetch.Response.mapSuccess(projects => projects->getExercisesCount->Array.length == 0)
      ->Util.Fetch.Response.toOption
      ->Option.getOr(false)}
      severity={Warning}
      title={Message(Message.Session.noExercises)}
    />
    {switch projects {
    | NotStarted => Jsx.null
    | Pending =>
      <Page alignContent={Stretch} spaceOnTop=true spaceOnBottom=true justifyItems="stretch">
        <Mui.Box
          display={String("grid")}
          gridTemplateColumns={String("1fr")}
          gridTemplateRows={String("auto auto 1fr")}
          sx={App_Theme.Classes.itemGaps->Mui.Sx.array}>
          <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
          <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
          <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
        </Mui.Box>
      </Page>
    | Ok(projects) =>
      <Page alignContent={Stretch} spaceOnTop=true spaceOnBottom=true justifyItems="stretch">
        <Common.Form
          header={<PageHeader message=Message.Session.selectProjectTitle />}
          gridTemplateRows="auto 1fr auto"
          submitButtonLabel=Message.Button.next
          onSubmit={form->Form.Content.handleSubmit((session, _event) => onSubmit(session))}
          onCancel
          submitPending=false>
          <Mui.Box
            display={String("grid")}
            gridTemplateColumns={String(smUp ? "1fr 1fr" : "1fr")}
            gridTemplateRows={String(smUp ? "auto auto 1fr" : "auto auto auto 1fr")}
            sx={App_Theme.Classes.itemGaps
            ->Array.concat(smUp ? App_Theme.Classes.itemGapsHorizontal : [])
            ->Mui.Sx.array}>
            {form->Form.Input.renderProjectName(
              ~intl,
              ~projectNames={projects->Array.map(({name}) => name)},
              ~onChange=onProjectNameChange,
              ~disabled={projects->Array.length == 0},
            )}
            {form->Form.Input.renderExerciseCount(
              ~intl,
              ~exercisesCount={projects->getExercisesCount},
              ~disabled={projects->getExercisesCount->Array.length == 0},
            )}
            {if selectedProject->getTopPriorityExercisesCount(~projects) == 0 {
              Jsx.null
            } else {
              <Mui.Card sx=?{smUp ? Some(Classes.topPrioInfoSpan) : None}>
                <Mui.CardContent>
                  <Mui.Box
                    display={String("grid")}
                    gridTemplateColumns={String("auto 1fr")}
                    gridTemplateRows={String("1fr")}
                    sx=Classes.topPrioInfoGap>
                    <Icon.PriorityHigh />
                    <Mui.Typography>
                      {intl
                      ->ReactIntl.Intl.formatMessageWithValues(
                        Message.Session.topPriorityCountInfoCard,
                        {
                          "count": selectedProject->getTopPriorityExercisesCount(~projects),
                        },
                      )
                      ->Jsx.string}
                    </Mui.Typography>
                  </Mui.Box>
                </Mui.CardContent>
              </Mui.Card>
            }}
            Jsx.null
          </Mui.Box>
        </Common.Form>
      </Page>
    | Error({message}) =>
      <Snackbar
        isOpen={projects->Util.Fetch.Response.isError}
        severity={Error}
        title={Message(Message.Session.couldNotLoadSession)}
        body={String(message)}
      />
    }}
  </>
}
