open Session_Util
open Session_Type

module ProjectName = Session_Create_Page_ProjectName
module ExerciseCount = Session_Create_Page_ExerciseCount

let getExercisesCount = (selectedProject, ~projects) =>
  selectedProject
  ->Option.map(getExerciseCountSelection)
  ->Option.getOr(projects->Array.get(0)->Option.map(getExerciseCountSelection)->Option.getOr([]))

let wrapWithResponsiveness = (~smUp, children) =>
  if smUp {
    <Mui.Box
      display={String("grid")}
      gridTemplateColumns={String("1fr 1fr")}
      gridTemplateRows={String("1fr")}
      sx={App_Theme.Classes.itemGaps
      ->Array.concat(App_Theme.Classes.itemGapsHorizontal)
      ->Mui.Sx.array}>
      {children->Jsx.array}
    </Mui.Box>
  } else {
    <> {children->Jsx.array} </>
  }

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

  [
    <ProjectName
      projectNames={projects->Array.map(({name}) => name)}
      projectName=?{selectedProject->Option.map(({name}) => name)}
      onChange=onProjectNameChange
      disabled={projects->Array.length == 0 || onAddClick->Option.isNone}
      key="project-name"
    />,
    <ExerciseCount
      exercisesCounts={selectedProject->getExercisesCount(~projects)}
      exercisesCount=?selectedExercisesCount
      onChange=onExercisesCountChange
      disabled={selectedProject->getExercisesCount(~projects)->Array.length == 0}
      key="exercises-count"
    />,
  ]->wrapWithResponsiveness(~smUp)
}
