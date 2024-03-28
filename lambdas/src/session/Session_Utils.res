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

let rec addMore = (
  ~exerciseCount,
  ~tempo,
  ~exercisesToBePracticedSlow,
  ~exercisesToBePracticedFast,
  result,
) => {
  if (
    exerciseCount == 0 ||
      (exercisesToBePracticedSlow->List.length == 0 && exercisesToBePracticedFast->List.length == 0)
  ) {
    result
  } else {
    let (nextToPractice, takenFromTempo) = if tempo == Slow {
      if exercisesToBePracticedSlow->List.head->Option.isNone {
        (exercisesToBePracticedFast->List.head->convertOption(~tempo), Fast)
      } else {
        (exercisesToBePracticedSlow->List.head->convertOption(~tempo), Slow)
      }
    } else if exercisesToBePracticedFast->List.head->Option.isNone {
      (exercisesToBePracticedSlow->List.head->convertOption(~tempo), Slow)
    } else {
      (exercisesToBePracticedFast->List.head->convertOption(~tempo), Fast)
    }

    nextToPractice
    ->Option.map(nextToPractice => result->Array.concat([nextToPractice]))
    ->Option.getOr(result)
    ->addMore(
      ~exerciseCount=exerciseCount - 1,
      ~tempo=tempo == Slow ? Fast : Slow,
      ~exercisesToBePracticedSlow=takenFromTempo == Slow
        ? exercisesToBePracticedSlow->List.tail->Option.getOr(list{})
        : exercisesToBePracticedSlow,
      ~exercisesToBePracticedFast=takenFromTempo == Fast
        ? exercisesToBePracticedFast->List.tail->Option.getOr(list{})
        : exercisesToBePracticedFast,
    )
  }
}

let createSession = ({project: {exercises, projectName, active}, exerciseCount}) => {
  let emptyResult = {projectName, exercises: list{}, topPriorityExercises: list{}}

  if active {
    let exerciseCount = exerciseCount->Int.mod(2) == 0 ? exerciseCount : exerciseCount - 1
    // Prepare input
    let exercises = exercises->Array.filter(({active}) => active)

    let neverPracticedExercises =
      exercises
      ->Array.filter(({?lastPracticed}) => lastPracticed->Option.isNone)
      ->sortByLastPracticedDateDate
    let exercisesToBePracticedSlow =
      exercises
      ->Array.filter(({?lastPracticed}) =>
        lastPracticed->Option.map(({tempo}) => tempo == Fast)->Option.getOr(false)
      )
      ->sortByLastPracticedDateDate
      ->List.fromArray
    let exercisesToBePracticedFast =
      exercises
      ->Array.filter(({?lastPracticed}) =>
        lastPracticed->Option.map(({tempo}) => tempo == Slow)->Option.getOr(false)
      )
      ->sortByLastPracticedDateDate
      ->List.fromArray

    // Prepare output
    let exercises =
      neverPracticedExercises
      ->Array.slice(~start=0, ~end=exerciseCount)
      ->Array.mapWithIndex((exercise, index) =>
        exercise->convert(~tempo=(index + 1)->Int.mod(2) == 0 ? Fast : Slow)
      )
      ->addMore(
        ~exerciseCount=exerciseCount - neverPracticedExercises->Array.length,
        ~tempo=neverPracticedExercises->Array.length->Int.mod(2) == 0 ? Slow : Fast,
        ~exercisesToBePracticedSlow,
        ~exercisesToBePracticedFast,
      )
      ->List.fromArray

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
