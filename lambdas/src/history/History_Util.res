open History_Type

let getExercisesMap = (~projectName, historyItemsMap) => historyItemsMap->Map.get(projectName)

let getTemposMap = (~projectName, ~exerciseName, historyItemsMap) =>
  historyItemsMap
  ->getExercisesMap(~projectName)
  ->Option.flatMap(exercises => exercises->Map.get(exerciseName))

let getTempoCount = (~projectName, ~exerciseName, ~tempo, historyItemsMap) =>
  historyItemsMap
  ->getTemposMap(~projectName, ~exerciseName)
  ->Option.flatMap(tempos => tempos->Map.get(tempo->Exercise.Type.tempo_encode->JSON.stringify))

let countTempo = (~projectName, ~exerciseName, ~tempo, ~historyItemsMap, temposMap) =>
  temposMap->Option.map(tempos => {
    tempos->Map.set(
      tempo->Exercise.Type.tempo_encode->JSON.stringify,
      historyItemsMap
      ->getTempoCount(~projectName, ~exerciseName, ~tempo)
      ->Option.getOr(0) + 1,
    )

    tempos
  })

let countExerciseAndTempo = (~projectName, ~exerciseName, ~tempo, ~historyItemsMap, exercisesMap) =>
  exercisesMap->Option.map(exercises => {
    exercises->Map.set(
      exerciseName,
      historyItemsMap
      ->getTemposMap(~projectName, ~exerciseName)
      ->countTempo(~historyItemsMap, ~projectName, ~exerciseName, ~tempo)
      ->Option.getOr([(tempo->Exercise.Type.tempo_encode->JSON.stringify, 1)]->Map.fromArray),
    )

    exercises
  })

let historyItemsToMap = historyItems =>
  historyItems
  ->Array.flatMap(({exercises}) => exercises)
  ->Array.reduce(Map.make(), (result, {projectName, name, tempo}) => {
    result->Map.set(
      projectName,
      result
      ->getExercisesMap(~projectName)
      ->countExerciseAndTempo(~historyItemsMap=result, ~projectName, ~exerciseName=name, ~tempo)
      ->Option.getOr(
        [
          (name, [(tempo->Exercise.Type.tempo_encode->JSON.stringify, 1)]->Map.fromArray),
        ]->Map.fromArray,
      ),
    )

    result
  })

let temposMapToCount = temposMap =>
  temposMap
  ->Map.values
  ->Iterator.toArray
  ->Array.reduce(0, (result, count) => result + count)

let temposMapToArray = temposMap =>
  temposMap
  ->Map.entries
  ->Iterator.toArray
  ->Array.map(((tempo, practiceCount)) => {
    tempo: tempo->JSON.parseExn->Exercise.Type.tempo_decode->Result.getOr(Slow),
    practiceCount,
  })
  ->Array.toSorted(({tempo: tempo1}, {tempo: tempo2}) =>
    tempo1
    ->Exercise.Type.tempo_encode
    ->JSON.stringify
    ->String.compare(tempo2->Exercise.Type.tempo_encode->JSON.stringify)
    ->Ordering.invert
  )

let exercisesMapToCount = exercisesMap =>
  exercisesMap
  ->Map.values
  ->Iterator.toArray
  ->Array.reduce(0, (result, byTempos) => result + byTempos->temposMapToCount)

let exercisesMapToArray = exercisesMap =>
  exercisesMap
  ->Map.entries
  ->Iterator.toArray
  ->Array.map(((exerciseName, byTempos)) => {
    exerciseName,
    practiceCount: byTempos->temposMapToCount,
    byTempos: byTempos->temposMapToArray,
  })
  ->Array.toSorted(({exerciseName: exerciseName1}, {exerciseName: exerciseName2}) =>
    exerciseName1->String.compare(exerciseName2)
  )

let mapToHistoryResponse = (historyItemsMap, notPracticedExercises) => {
  historyItemsMap
  ->Map.entries
  ->Iterator.toArray
  ->Array.map(((projectName, byExercises)) => {
    projectName,
    practiceCount: byExercises->exercisesMapToCount,
    byExercises: byExercises->exercisesMapToArray,
    notPracticedExercises: notPracticedExercises->Map.get(projectName)->Option.getOr([]),
  })
  ->Array.toSorted(({projectName: projectName1}, {projectName: projectName2}) =>
    projectName1->String.compare(projectName2)
  )
}

let getNotPracticedExercises = (~dateFrom=?, allProjects: array<Project.Type.t>) =>
  allProjects
  ->Array.map(({name, exercises}) => (
    name,
    exercises
    ->Array.filter(({active, ?lastPracticed}) =>
      active &&
      lastPracticed
      ->Option.map(
        ({date}) =>
          dateFrom
          ->Option.map(dateFrom => date->Date.compare(dateFrom)->Ordering.isLess)
          ->Option.getOr(false),
      )
      ->Option.getOr(true)
    )
    ->Array.map(({name}) => name),
  ))
  ->Map.fromArray

let toHistoryResponse = (~dateFrom=?, historyItems, allProjects) => {
  historyItems
  ->historyItemsToMap
  ->mapToHistoryResponse(allProjects->getNotPracticedExercises(~dateFrom?))
}
