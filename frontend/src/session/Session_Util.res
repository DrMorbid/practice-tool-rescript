let getExerciseCountSelection = projects => {
  let activeExerciseCount =
    projects
    ->Array.flatMap(({exercises}: Project.Type.t) =>
      exercises->Array.filter(({active, topPriority}) => active && !topPriority)
    )
    ->Array.length

  Int.range(2, activeExerciseCount, ~options={step: 2, inclusive: true})
}
