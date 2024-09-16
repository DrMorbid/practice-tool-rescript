let getExerciseCountSelection = ({exercises}: Project.Type.t) => {
  let activeExerciseCount =
    exercises
    ->Array.filter(({active, topPriority}) => active && !topPriority)
    ->Array.length

  if activeExerciseCount == 0 {
    []
  } else {
    Int.range(2, activeExerciseCount, ~options={step: 2, inclusive: true})
  }
}

let setSelectedExerciseCount = (~form, project) =>
  switch project->Option.flatMap(project =>
    project
    ->getExerciseCountSelection
    ->Array.get(0)
  ) {
  | Some(exerciseCount) => form->Session_Page_Form.Input.ExerciseCount.setValue(exerciseCount)
  | None => form->Session_Page_Form.Input.ExerciseCount.setValue(0)
  }

let findProject = (~projectName, projects) =>
  projects->Util.Fetch.Response.mapSuccess(projects => {
    projects->Array.find(({name}: Project.Type.t) => name == projectName)
  })

let setSelectedExerciseCountForProject = (~form, ~projectName, projects) =>
  projects
  ->findProject(~projectName)
  ->Util.Fetch.Response.forSuccess(setSelectedExerciseCount(~form, _))

let resetForm = (~form, projects) =>
  projects->Util.Fetch.Response.forSuccess(projects => {
    let firstProject = projects->Array.get(0)

    firstProject->Option.forEach(({name}: Project.Type.t) =>
      form->Session_Page_Form.Input.ProjectName.setValue(name)
    )

    firstProject->setSelectedExerciseCount(~form)
  })

let getTopPriorityExercisesCount = (~projects, selectedProject) =>
  selectedProject
  ->Option.map(({exercises}: Project.Type.t) => exercises)
  ->Option.getOr(
    projects
    ->Array.get(0)
    ->Option.map(({exercises}: Project.Type.t) => exercises)
    ->Option.getOr([]),
  )
  ->Array.filter(({active, topPriority}) => active && topPriority)
  ->Array.length
