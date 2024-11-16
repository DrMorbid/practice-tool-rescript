open Session_Util
open Session_Type

module Form = Session_Create_Page_SessionSelection_Form

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
  let removeButton = ReactDOM.Style.make(~justifyItems="end", ())->MuiStyles.styleToSx
}

let getExercisesCount = (selectedProject, ~projects) =>
  selectedProject
  ->Option.map(getExerciseCountSelection)
  ->Option.getOr(projects->Array.get(0)->Option.map(getExerciseCountSelection)->Option.getOr([]))

@react.component
let make = (
  ~projects: array<Project.Type.t>,
  ~onChange,
  ~preselectedProject=?,
  ~preselectedExercisesCount=?,
  ~onAddClick=?,
  ~onRemoveClick=?,
) => {
  let (selectedProject, setSelectedProject) = React.useState(() => None)
  let (selectedExercisesCount, setSelectedExercisesCount) = React.useState(() => None)
  let smUp = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smUp)
  let intl = ReactIntl.useIntl()

  React.useEffect(() => {
    setSelectedProject(_ =>
      preselectedProject->Option.map(project => Some(project))->Option.getOr(projects->Array.get(0))
    )
    setSelectedExercisesCount(_ => preselectedExercisesCount)

    None
  }, (preselectedProject, preselectedExercisesCount))

  React.useEffect(() => {
    setSelectedExercisesCount(selectedExercisesCount => {
      selectedExercisesCount
      ->Option.map(exerciseCount => Some(exerciseCount))
      ->Option.getOr(selectedProject->getExercisesCount(~projects)->Array.get(0))
    })

    None
  }, [selectedProject])

  React.useEffect(() => {
    switch (selectedProject, selectedExercisesCount) {
    | (Some({name: projectName}), Some(exercisesCount)) => onChange({projectName, exercisesCount})
    | _ => ()
    }

    None
  }, (selectedProject, selectedExercisesCount))

  <>
    <Snackbar
      isOpen={selectedProject->getExercisesCount(~projects)->Array.length == 0}
      severity={Warning}
      title={Message(Message.Session.noExercises)}
    />
    <Mui.Box
      display={String("grid")}
      gridTemplateColumns={String("1fr")}
      gridTemplateRows={String(
        switch (smUp, selectedProject->getTopPriorityExercisesCount(~projects)) {
        | (false, 0) => "auto auto auto 1fr"
        | (false, _) => "auto auto auto auto 1fr"
        | (true, 0) => "auto auto 1fr"
        | (true, _) => "auto auto auto 1fr"
        },
      )}
      sx={App_Theme.Classes.itemGaps->Mui.Sx.array}>
      <Mui.Box gridColumn=?{smUp ? Some(String("span 2")) : None}>
        {onRemoveClick
        ->Option.map(onClick =>
          <Mui.Box display={String("grid")} sx=Classes.removeButton>
            <Mui.IconButton color={Secondary} onClick>
              <Icon.Close />
            </Mui.IconButton>
          </Mui.Box>
        )
        ->Option.getOr(<EmptyIconSpace dense={!smUp} />)}
      </Mui.Box>
      <Form projects onChange ?preselectedProject ?preselectedExercisesCount ?onAddClick />
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
      <Mui.Box gridColumn=?{smUp ? Some(String("span 2")) : None}>
        {switch onAddClick {
        | Some(onClick) if projects->Array.length > 1 =>
          <Mui.IconButton color={Secondary} onClick>
            <Icon.Add />
          </Mui.IconButton>
        | _ => smUp ? <EmptyIconSpace /> : Jsx.null
        }}
      </Mui.Box>
    </Mui.Box>
  </>
}
