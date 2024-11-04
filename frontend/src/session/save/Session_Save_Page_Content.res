module ExerciseCards = Session_Save_Page_ExerciseCards

module Classes = {
  let exercise = ReactDOM.Style.make(~overflow="visible", ())->MuiStyles.styleToSx
}

@react.component
let make = () => {
  let (sessions, setSessions) = React.useState(() => [])
  let (toPractice, setToPractice) = React.useState(() => Util.Fetch.Response.NotStarted)
  let (savePending, setSavePending) = React.useState(() => [])
  let (error, setError) = React.useState(() => None)
  let searchParams = Next.Navigation.useSearchParams()
  let auth = ReactOidcContext.useAuth()
  let router = Next.Navigation.useRouter()
  let intl = ReactIntl.useIntl()

  React.useEffect(() => {
    searchParams
    ->Next.Navigation.URLSearchParams.get("sessions")
    ->Nullable.toOption
    ->Option.map(searchParam =>
      Spice.arrayFromJson(Session_Type.t_decode, searchParam->JSON.parseExn)
    )
    ->Option.forEach(sessions =>
      switch sessions {
      | Ok(sessions) => setSessions(_ => sessions)
      | Error(error) =>
        setError(
          _ => Some((
            ({message: error.message}: Util.Fetch.Response.error),
            Message.Session.couldNotDecodeSession,
          )),
        )
      }
    )

    None
  }, [searchParams])

  React.useEffect(() => {
    setToPractice(_ => Pending)

    sessions->Array.forEach(({projectName, exercisesCount}) =>
      Util.Fetch.fetch(
        SessionWithNameAndCount(projectName, exercisesCount),
        ~method=Get,
        ~auth,
        ~responseDecoder=Session_Type.toPractice_decode,
        ~router,
      )
      ->Promise.thenResolve(
        result =>
          switch result {
          | Ok(toPracticeNew) =>
            setToPractice(
              toPractice =>
                switch toPractice {
                | NotStarted | Error(_) => toPractice
                | Pending => Ok([toPracticeNew])
                | Ok(toPractice) => Ok(toPractice->Array.concat([toPracticeNew]))
                },
            )
          | Error(error) => setToPractice(_ => Error(error))
          },
      )
      ->ignore
    )

    None
  }, [sessions])

  let onSave = _ => {
    setSavePending(_ =>
      toPractice
      ->Util.Fetch.Response.mapSuccess(toPractice => toPractice->Array.map(_ => true))
      ->Util.Fetch.Response.toOption
      ->Option.getOr([])
    )

    toPractice->Util.Fetch.Response.forSuccess(
      Array.forEachWithIndex(_, (toPractice, index) =>
        Util.Fetch.fetch(
          Session,
          ~method=Post,
          ~auth,
          ~responseDecoder=Spice.stringFromJson,
          ~body=toPractice
          ->Session_Util.toSaveSessionRequest
          ->Session_Type.practiced_encode,
          ~router,
        )
        ->Promise.thenResolve(result => {
          setSavePending(
            savePending =>
              savePending->Array.mapWithIndex(
                (savePending, index2) => index2 == index ? false : savePending,
              ),
          )

          switch result {
          | Ok(_) => {
              Store.dispatch(
                StoreProcessFinishedSuccessfullyMessage(
                  String(
                    intl->ReactIntl.Intl.formatMessage(Message.Session.sessionSavedSuccessfully),
                  ),
                ),
              )
              router->Route.FrontEnd.push(~route=Practice)
            }
          | Error(error) => setError(_ => Some((error, Message.Project.couldNotSaveProject)))
          }
        })
        ->ignore
      ),
    )
  }

  let onBack = _ => router->Route.FrontEnd.push(~route=Practice)

  let indexOf = name =>
    sessions
    ->Array.map(({projectName}) => projectName)
    ->Array.indexOf(name)

  <>
    {error
    ->Option.map((({message}, title)) =>
      <Snackbar
        isOpen={error->Option.isSome} severity={Error} title={Message(title)} body={String(message)}
      />
    )
    ->Option.getOr(Jsx.null)}
    {switch toPractice {
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
    | Ok(sessionsToPractice) =>
      <Page alignContent={Stretch} spaceOnTop=true spaceOnBottom=true justifyItems="stretch">
        <Common_PageContent
          onPrimary=onSave
          onSecondary=onBack
          secondaryButtonLabel=Message.Button.back
          header={<PageHeader message=Message.Session.startPracticingTitle />}
          gridTemplateRows="auto 1fr auto"
          actionPending={savePending->Array.find(savePending => savePending)->Option.isSome}>
          <Mui.Grid
            display={String("grid")}
            sx={[App_Theme.Classes.scrollable]
            ->Array.concat(App_Theme.Classes.itemGaps)
            ->Mui.Sx.array}>
            {sessionsToPractice
            ->Array.toSorted(({name: name1}, {name: name2}) =>
              name1
              ->indexOf
              ->Int.compare(name2->indexOf)
            )
            ->Array.mapWithIndex(({name, exercises, topPriorityExercises}, index) =>
              <Mui.Grid
                display={String("grid")}
                sx={App_Theme.Classes.itemGapsSm->Mui.Sx.array}
                key={`session-${index->Int.toString}`}>
                <Mui.Typography variant={H5}> {name->Jsx.string} </Mui.Typography>
                <Mui.Grid
                  display={String("grid")}
                  alignContent={String("start")}
                  sx={App_Theme.Classes.itemGaps->Mui.Sx.array}>
                  <ExerciseCards exercises={topPriorityExercises->List.concat(exercises)} />
                </Mui.Grid>
              </Mui.Grid>
            )
            ->Jsx.array}
          </Mui.Grid>
        </Common_PageContent>
      </Page>
    | Error({message}) =>
      <Snackbar
        isOpen={toPractice->Util.Fetch.Response.isError}
        severity={Error}
        title={Message(Message.Project.couldNotLoadProject)}
        body={String(message)}
      />
    }}
  </>
}
