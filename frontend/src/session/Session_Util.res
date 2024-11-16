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

let toSaveSessionRequest = (
  {name, exercises, topPriorityExercises}: Session_Type.toPractice,
): Session_Type.practiced => [
  {
    name,
    exercises: exercises
    ->List.concat(topPriorityExercises)
    ->List.map(({name, tempo}): Exercise.Type.practiced => {name, tempo})
    ->List.toArray,
  },
]
