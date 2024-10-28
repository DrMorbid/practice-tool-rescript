open Session_Type

module SessionSelection = Session_Create_Page_SessionSelection

@react.component
let default = () => {
  let (projects, setProjects) = React.useState(() => Util.Fetch.Response.NotStarted)
  let (
    alreadySelectedSessions: Map.t<string, Session_Type.t>,
    setAlreadySelectedSessions,
  ) = React.useState(() => Map.make())
  let (currentlySelectedSession, setCurrentlySelectedSession) = React.useState(() => None)
  // TODO To be deleted
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
      | Ok(projects) => setProjects(_ => Ok(projects->Array.filter(({active}) => active)))
      | Error(error) => setProjects(_ => Error(error))
      }
    )
    ->ignore

    None
  }, [])

  React.useEffect(() => {
    // projects->resetForm(~form)

    None
  }, [projects])

  let onSubmit = ({projectName, exercisesCount}) =>
    router->Route.FrontEnd.push(~route=PracticeOverview(projectName, exercisesCount))

  let onCancel = _ => {
    // projects->resetForm(~form)
    // setSelectedProject(_ => None)
    ()
  }

  let onAddClick = _ => {
    currentlySelectedSession->Option.forEach(currentlySelectedSession => {
      setAlreadySelectedSessions(alreadySelectedSessions =>
        alreadySelectedSessions
        ->Map.entries
        ->Iterator.toArray
        ->Array.concat([(currentlySelectedSession.projectName, currentlySelectedSession)])
        ->Map.fromArray
      )

      setCurrentlySelectedSession(_ => None)
    })
  }

  let onRemoveClick = _ => {
    let sessionsArray =
      alreadySelectedSessions
      ->Map.entries
      ->Iterator.toArray

    setCurrentlySelectedSession(_ =>
      sessionsArray->Array.map(((_, session)) => session)->Array.last
    )

    setAlreadySelectedSessions(_ =>
      sessionsArray
      ->Array.slice(~start=0, ~end=alreadySelectedSessions->Map.size - 1)
      ->Map.fromArray
    )
  }

  let onValuesChanged = (session, ~projectName=?) => {
    switch projectName {
    | Some(projectName) =>
      setAlreadySelectedSessions(alreadySelectedSessions =>
        alreadySelectedSessions
        ->Map.entries
        ->Iterator.toArray
        ->Array.map(((alreadySelectedProjectName, alreadySelectedSession)) =>
          if alreadySelectedProjectName == projectName {
            (alreadySelectedProjectName, session)
          } else {
            (alreadySelectedProjectName, alreadySelectedSession)
          }
        )
        ->Map.fromArray
      )
    | None => setCurrentlySelectedSession(_ => Some(session))
    }
  }

  Console.log3(
    "FKR: page render: alreadySelectedSessions=%o, currentlySelectedSession=%o",
    alreadySelectedSessions,
    currentlySelectedSession,
  )

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
        <Common.PageContent
          header={<PageHeader message=Message.Session.selectProjectsTitle />}
          gridTemplateRows={"auto 1fr auto"}
          primaryButtonLabel=Message.Button.next
          onSecondary=onCancel
          actionPending=false>
          <Mui.Box
            display={String("grid")}
            alignContent={String("start")}
            gridTemplateColumns={String("1fr")}
            gridTemplateRows={String(
              `${alreadySelectedSessions
                ->Map.entries
                ->Iterator.toArray
                ->Array.map(_ => "auto")
                ->Array.join(" ")} 1fr`,
            )}
            sx={[App_Theme.Classes.scrollable]
            ->Array.concat(App_Theme.Classes.itemGapsLg)
            ->Mui.Sx.array}>
            {alreadySelectedSessions
            ->Map.entries
            ->Iterator.toArray
            ->Array.mapWithIndex(((projectName, session), index) =>
              <SessionSelection
                projects
                preselectedProject=?{projects->Array.find(({name}) => projectName == name)}
                preselectedExercisesCount={session.exercisesCount}
                onChange={onValuesChanged(_, ~projectName)}
                key={`session-selection-${index->Int.toString}`}
              />
            )
            ->Jsx.array}
            <SessionSelection
              projects={projects->Array.filter(({name}) =>
                !(alreadySelectedSessions->Map.keys->Iterator.toArray->Array.includes(name))
              )}
              preselectedProject=?{currentlySelectedSession
              ->Option.map(({projectName}) => projectName)
              ->Option.flatMap(projectName =>
                projects->Array.find(({name}) => name == projectName)
              )}
              preselectedExercisesCount=?{currentlySelectedSession->Option.map(({exercisesCount}) =>
                exercisesCount
              )}
              onAddClick
              onRemoveClick=?{alreadySelectedSessions->Map.size == 0 ? None : Some(onRemoveClick)}
              onChange={onValuesChanged(_)}
            />
          </Mui.Box>
        </Common.PageContent>
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
