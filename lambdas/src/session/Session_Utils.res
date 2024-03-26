open AWS.Lambda
open Utils.Lambda
open Session_Type
open Exercise.Type
open Exercise.Utils

let getSessionConfiguration = event =>
  event
  ->getUser
  ->Result.flatMap((userId): result<practiceSessionDBRequest, response> =>
    event.pathParameters
    ->Option.flatMap(({projectName, exerciseCount}) =>
      Some({name: projectName})
      ->Project.Utils.toProjectTableKey(~userId)
      ->Option.map(projectTableKey => {projectTableKey, exerciseCount})
    )
    ->Option.map(practiceSessionRequest => Ok(practiceSessionRequest))
    ->Option.getOr(
      Error({statusCode: 400, body: "Project name must be present in path parameters"}),
    )
  )

let createSession = ({project: {exercises, projectName, active}, exerciseCount}) => {
  let emptyResult = {projectName, exercises: list{}, topPriorityExercises: list{}}

  if active && exerciseCount->Int.mod(2) == 0 {
    // Prepare input
    let exercises = exercises->Array.filter(({active}) => active)
    let neverPracticedExercises =
      exercises->Array.filter(({?lastPracticed}) => lastPracticed->Option.isNone)
    let alreadyPracticedExercises =
      exercises
      ->Array.filter(({?lastPracticed}) => lastPracticed->Option.isSome)
      ->Array.toSorted((exercise1, exercise2) =>
        exercise1.lastPracticed->Option.compare(exercise2.lastPracticed, (
          lastPracticed1,
          lastPracticed2,
        ) => lastPracticed1.date->Date.compare(lastPracticed2.date))
      )

    // Calculate output
    let calculatedNeverPracticedExercises =
      neverPracticedExercises
      ->Array.slice(~start=0, ~end=exerciseCount)
      ->Array.mapWithIndex(({exerciseName, fastTempo, slowTempo}, index) => {
        exerciseName,
        tempo: (index + 1)->Int.mod(2) == 0 ? Fast : Slow,
        tempoValue: (index + 1)->Int.mod(2) == 0 ? fastTempo : slowTempo,
      })
      ->List.fromArray
    let exercises = if calculatedNeverPracticedExercises->List.size < exerciseCount {
      calculatedNeverPracticedExercises->List.concat(
        alreadyPracticedExercises
        ->Array.slice(~start=0, ~end=exerciseCount - calculatedNeverPracticedExercises->List.size)
        ->Array.map(switchTempo)
        ->Array.keepSome
        ->List.fromArray,
      )
    } else {
      calculatedNeverPracticedExercises
    }

    let result = {...emptyResult, exercises}
    Console.log3(
      "Created practice session %s for poject %s",
      result->JSON.stringifyAnyWithIndent(2),
      projectName,
    )
    result
  } else {
    emptyResult
  }
}
