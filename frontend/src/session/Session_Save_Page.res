module ExerciseCards = Session_Save_Page_ExerciseCards

module Classes = {
  let exercise = ReactDOM.Style.make(~overflow="visible", ())->MuiStyles.styleToSx
}

@react.component
let default = () => {
  let (projectName, setProjectName) = React.useState(() => None)
  let (exerciseCount, setExerciseCount) = React.useState(() => None)
  let (session, setSession) = React.useState(() => Util.Fetch.Response.NotStarted)
  let searchParams = Next.Navigation.useSearchParams()
  let auth = ReactOidcContext.useAuth()

  React.useEffect(() => {
    setProjectName(_ =>
      searchParams->Next.Navigation.URLSearchParams.get("projectName")->Nullable.toOption
    )
    setExerciseCount(_ =>
      searchParams
      ->Next.Navigation.URLSearchParams.get("exerciseCount")
      ->Nullable.toOption
      ->Option.flatMap(Int.fromString(_))
    )

    None
  }, [searchParams])

  React.useEffect(() => {
    setSession(_ => Pending)

    switch (projectName, exerciseCount) {
    | (Some(projectName), Some(exerciseCount)) =>
      Util.Fetch.fetch(
        SessionWithNameAndCount(projectName, exerciseCount),
        ~method=Get,
        ~auth,
        ~responseDecoder=Session_Type.toPractice_decode,
      )
      ->Promise.thenResolve(result =>
        switch result {
        | Ok(toPractice) => setSession(_ => Ok(toPractice))
        | Error(error) => setSession(_ => Error(error))
        }
      )
      ->ignore
    | _ => ()
    }

    None
  }, (projectName, exerciseCount))

  let onSave = _ => ()

  let onBack = _ => ()

  switch session {
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
  | Ok({name, topPriorityExercises, exercises}) =>
    <Page alignContent={Stretch} spaceOnTop=true spaceOnBottom=true justifyItems="stretch">
      <Common_PageContent
        onPrimary=onSave
        onSecondary=onBack
        secondaryButtonLabel=Message.Button.back
        header={<PageHeader message=Message.Session.startPracticingTitle />}
        gridTemplateRows="auto auto 1fr auto"
        actionPending=false>
        <Mui.Typography variant={H5}> {name->Jsx.string} </Mui.Typography>
        <Mui.Grid
          display={String("grid")}
          alignContent={String("start")}
          sx={App_Theme.Classes.itemGaps
          ->Array.concat([ReactDOM.Style.make(~overflow="auto", ())->MuiStyles.styleToSxArray])
          ->Mui.Sx.array}>
          <ExerciseCards exercises={topPriorityExercises->List.concat(exercises)} />
        </Mui.Grid>
      </Common_PageContent>
    </Page>
  | Error({message}) =>
    <Snackbar
      isOpen={session->Util.Fetch.Response.isError}
      severity={Error}
      title={Message(Message.Project.couldNotLoadProject)}
      body={String(message)}
    />
  }
}
