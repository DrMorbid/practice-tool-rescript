open History_Type

let toHistoryResponse = historyItems => {
  let historyExercises = historyItems->Array.flatMap(({exercises}) => exercises)

  let statisticsByExercises =
    historyExercises
    ->Array.reduce(Map.make(), (result, {projectName, name}) => {
      result->Map.set(
        projectName,
        result
        ->Map.get(projectName)
        ->Option.map(exercises => {
          exercises->Map.set(
            name,
            result
            ->Map.get(projectName)
            ->Option.flatMap(exercises => exercises->Map.get(name))
            ->Option.getOr(0) + 1,
          )

          exercises
        })
        ->Option.getOr(Map.make()),
      )

      result
    })
    ->Map.entries
    ->Iterator.toArray
    ->Array.map(((projectName, byExercises)) => {
      projectName,
      practiceCount: byExercises
      ->Map.values
      ->Iterator.toArray
      ->Array.reduce(0, (result, count) => result + count),
      byExercises: byExercises
      ->Map.entries
      ->Iterator.toArray
      ->Array.map(((exerciseName, practiceCount)) => {
        exerciseName,
        practiceCount,
        byTempos: [],
      })
      ->Array.toSorted(({exerciseName: exerciseName1}, {exerciseName: exerciseName2}) =>
        exerciseName1->String.compare(exerciseName2)
      ),
    })
    ->Array.toSorted(({projectName: projectName1}, {projectName: projectName2}) =>
      projectName1->String.compare(projectName2)
    )

  statisticsByExercises
}
