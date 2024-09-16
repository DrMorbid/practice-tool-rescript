open Session_Util

module Form = Session_Page_Form

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

  React.useEffect(() => {
    setProjects(_ => Pending)

    Util.Fetch.fetch(Project, ~method=Get, ~auth, ~responseDecoder=Project_Type.projects_decode)
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

  let onSubmit = projectName => Console.log2("FKR: selected project name is %o", projectName)

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

  switch projects {
  | NotStarted => Jsx.null
  | Pending => <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
  | Ok(projects) =>
    <Page alignContent={Stretch} spaceOnTop=true spaceOnBottom=true justifyItems="stretch">
      <Common.Form
        header={<FormHeader message=Message.Session.selectProjectTitle />}
        gridTemplateRows="auto 1fr auto"
        onSubmit={form->Form.Content.handleSubmit((projectName, _event) => onSubmit(projectName))}
        onCancel
        submitPending=false>
        <Mui.Box
          display={String("grid")}
          gridTemplateColumns={String("1fr")}
          gridTemplateRows={String("auto auto auto 1fr")}
          sx={Common.Form.Classes.formGaps->Mui.Sx.array}>
          {form->Form.Input.renderProjectName(
            ~intl,
            ~projectNames={projects->Array.map(({name}) => name)},
            ~onChange=onProjectNameChange,
          )}
          {form->Form.Input.renderExerciseCount(
            ~intl,
            ~exercisesCount={projects->getExercisesCount},
            ~disabled={projects->getExercisesCount->Array.length == 0},
          )}
          {if selectedProject->getTopPriorityExercisesCount(~projects) == 0 {
            Jsx.null
          } else {
            <Mui.Card>
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
      title={Message(Message.Manage.couldNotLoadProject)}
      body={String(message)}
    />
  }
}
