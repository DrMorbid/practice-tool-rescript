open AWS.Lambda
open Utils.Lambda
open Session_Type
open Exercise.Type

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

  if active {
    let exercises = exercises->Array.filter(({active}) => active)
    let neverPracticedExercises =
      exercises->Array.filter(({?lastPracticed}) => lastPracticed->Option.isNone)

    {
      ...emptyResult,
      exercises: neverPracticedExercises
      ->Array.mapWithIndex(({exerciseName, fastTempo, slowTempo}, index) => {
        exerciseName,
        tempo: (index + 1)->Int.mod(2) == 0 ? Fast : Slow,
        tempoValue: (index + 1)->Int.mod(2) == 0 ? fastTempo : slowTempo,
      })
      ->Array.slice(~start=0, ~end=exerciseCount)
      ->List.fromArray,
    }
  } else {
    emptyResult
  }
}
