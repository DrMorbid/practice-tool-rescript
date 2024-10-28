open Session_Util
open Session_Type

module ProjectName = Session_Create_Page_ProjectName
module ExerciseCount = Session_Create_Page_ExerciseCount

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

  let onProjectNameChange = event => {
    let selectedProject =
      projects->Array.find(({name}: Project.Type.t) =>
        name == (event->ReactEvent.Form.target)["value"]
      )

    setSelectedProject(_ => selectedProject)
    setSelectedExercisesCount(_ => None)
  }

  let onExercisesCountChange = event =>
    setSelectedExercisesCount(_ => (event->ReactEvent.Form.target)["value"]->Int.fromString)

  <>
    <Snackbar
      isOpen={selectedProject->getExercisesCount(~projects)->Array.length == 0}
      severity={Warning}
      title={Message(Message.Session.noExercises)}
    />
    <Mui.Box
      display={String("grid")}
      gridTemplateColumns={String(smUp ? "1fr 1fr" : "1fr")}
      gridTemplateRows={String(
        switch (smUp, onAddClick) {
        | (false, None) => "auto auto"
        | (false, Some(_)) => "auto auto 1fr"
        | (true, None) => "auto"
        | (true, Some(_)) => "auto 1fr"
        },
      )}
      sx={App_Theme.Classes.itemGaps
      ->Array.concat(smUp ? App_Theme.Classes.itemGapsHorizontal : [])
      ->Mui.Sx.array}>
      <ProjectName
        projectNames={projects->Array.map(({name}) => name)}
        projectName=?{selectedProject->Option.map(({name}) => name)}
        onChange=onProjectNameChange
        disabled={projects->Array.length == 0 || onAddClick->Option.isNone}
      />
      <ExerciseCount
        exercisesCounts={selectedProject->getExercisesCount(~projects)}
        exercisesCount=?selectedExercisesCount
        onChange=onExercisesCountChange
        disabled={selectedProject->getExercisesCount(~projects)->Array.length == 0}
      />
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
      {switch onAddClick {
      | Some(onClick) if projects->Array.length > 1 =>
        <Mui.Box>
          <Mui.IconButton color={Secondary} onClick>
            <Icon.Add />
          </Mui.IconButton>
        </Mui.Box>
      | _ => Jsx.null
      }}
    </Mui.Box>
  </>
}
