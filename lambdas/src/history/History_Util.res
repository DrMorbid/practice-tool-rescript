open History_Type

//TODO: Refactor this instanity
let toHistoryResponse = historyItems => {
  historyItems
  ->Array.flatMap(({exercises}) => exercises)
  ->Array.reduce(Map.make(), (result, {projectName, name, tempo}) => {
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
          ->Option.map(
            tempos => {
              tempos->Map.set(
                tempo->Exercise.Type.tempo_encode->JSON.stringify,
                result
                ->Map.get(projectName)
                ->Option.flatMap(exercises => exercises->Map.get(name))
                ->Option.flatMap(
                  tempos => tempos->Map.get(tempo->Exercise.Type.tempo_encode->JSON.stringify),
                )
                ->Option.getOr(0) + 1,
              )

              tempos
            },
          )
          ->Option.getOr([(tempo->Exercise.Type.tempo_encode->JSON.stringify, 1)]->Map.fromArray),
        )

        exercises
      })
      ->Option.getOr(
        [
          (name, [(tempo->Exercise.Type.tempo_encode->JSON.stringify, 1)]->Map.fromArray),
        ]->Map.fromArray,
      ),
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
    ->Array.reduce(0, (result, byTempos) =>
      result +
      byTempos
      ->Map.values
      ->Iterator.toArray
      ->Array.reduce(0, (result, count) => result + count)
    ),
    byExercises: byExercises
    ->Map.entries
    ->Iterator.toArray
    ->Array.map(((exerciseName, byTempos)) => {
      exerciseName,
      practiceCount: byTempos
      ->Map.values
      ->Iterator.toArray
      ->Array.reduce(0, (result, count) => result + count),
      byTempos: byTempos
      ->Map.entries
      ->Iterator.toArray
      ->Array.map(
        ((tempo, practiceCount)) => {
          tempo: tempo->JSON.parseExn->Exercise.Type.tempo_decode->Result.getOr(Slow),
          practiceCount,
        },
      )
      ->Array.toSorted(
        ({tempo: tempo1}, {tempo: tempo2}) =>
          tempo1
          ->Exercise.Type.tempo_encode
          ->JSON.stringify
          ->String.compare(tempo2->Exercise.Type.tempo_encode->JSON.stringify)
          ->Ordering.invert,
      ),
    })
    ->Array.toSorted(({exerciseName: exerciseName1}, {exerciseName: exerciseName2}) =>
      exerciseName1->String.compare(exerciseName2)
    ),
  })
  ->Array.toSorted(({projectName: projectName1}, {projectName: projectName2}) =>
    projectName1->String.compare(projectName2)
  )
}
