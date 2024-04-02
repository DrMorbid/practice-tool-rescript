open AWS.Lambda
open Utils.Lambda
open Session_Type
open Exercise.Utils

type sessionCalculationInput = {
  neverPracticedTopPriorityExercises: array<Exercise.Type.t>,
  topPriorityExercisesToBePracticedSlow: list<Exercise.Type.t>,
  topPriorityExercisesToBePracticedFast: list<Exercise.Type.t>,
  neverPracticedExercises: array<Exercise.Type.t>,
  exercisesToBePracticedSlow: list<Exercise.Type.t>,
  exercisesToBePracticedFast: list<Exercise.Type.t>,
}

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

let rec addAlreadyPracticedExercises = (
  ~tempo=?,
  ~exerciseCount,
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
    let (nextToPractice, takenFromTempo) = switch tempo {
    | Some(tempo) =>
      if tempo == Exercise.Type.Slow {
        if exercisesToBePracticedSlow->List.head->Option.isNone {
          (exercisesToBePracticedFast->List.head->convertOption(~tempo), Exercise.Type.Fast)
        } else {
          (exercisesToBePracticedSlow->List.head->convertOption(~tempo), Slow)
        }
      } else if exercisesToBePracticedFast->List.head->Option.isNone {
        (exercisesToBePracticedSlow->List.head->convertOption(~tempo), Slow)
      } else {
        (exercisesToBePracticedFast->List.head->convertOption(~tempo), Fast)
      }
    | None =>
      if exercisesToBePracticedSlow->List.head->Option.isNone {
        (exercisesToBePracticedFast->List.head->convertOption(~tempo=Fast), Fast)
      } else {
        (exercisesToBePracticedSlow->List.head->convertOption(~tempo=Slow), Slow)
      }
    }

    nextToPractice
    ->Option.map(nextToPractice => result->Array.concat([nextToPractice]))
    ->Option.getOr(result)
    ->addAlreadyPracticedExercises(
      ~exerciseCount=exerciseCount - 1,
      ~tempo=tempo
      ->Option.map(tempo => tempo == Slow ? Exercise.Type.Fast : Slow)
      ->Option.getOr(Fast),
      ~exercisesToBePracticedSlow=takenFromTempo == Slow
        ? exercisesToBePracticedSlow->List.tail->Option.getOr(list{})
        : exercisesToBePracticedSlow,
      ~exercisesToBePracticedFast=takenFromTempo == Fast
        ? exercisesToBePracticedFast->List.tail->Option.getOr(list{})
        : exercisesToBePracticedFast,
    )
  }
}

let getNeverPracticedExercises = (~onlyTopPriority=false, exercises: array<Exercise.Type.t>) =>
  exercises
  ->Array.filter(({topPriority}) => topPriority == onlyTopPriority)
  ->Array.filter(({?lastPracticed}) => lastPracticed->Option.isNone)
  ->sortByLastPracticedDateDate

let getExercisesToBePracticedSlow = (~onlyTopPriority=false, exercises: array<Exercise.Type.t>) =>
  exercises
  ->Array.filter(({topPriority}) => topPriority == onlyTopPriority)
  ->Array.filter(({?lastPracticed}) =>
    lastPracticed->Option.map(({tempo}) => tempo == Fast)->Option.getOr(false)
  )
  ->sortByLastPracticedDateDate
  ->List.fromArray

let getExercisesToBePracticedFast = (~onlyTopPriority=false, exercises: array<Exercise.Type.t>) =>
  exercises
  ->Array.filter(({topPriority}) => topPriority == onlyTopPriority)
  ->Array.filter(({?lastPracticed}) =>
    lastPracticed->Option.map(({tempo}) => tempo == Slow)->Option.getOr(false)
  )
  ->sortByLastPracticedDateDate
  ->List.fromArray

let pickExercisesToBePracticed = (
  ~topPriority=false,
  ~neverPracticedExercises,
  ~exercisesToBePracticedSlow,
  ~exercisesToBePracticedFast,
  ~exerciseCount,
) => {
  let neverPracticedCount = neverPracticedExercises->Array.length
  neverPracticedExercises
  ->Array.slice(~start=0, ~end=exerciseCount)
  ->Array.mapWithIndex((exercise, index) =>
    exercise->convert(~tempo=(index + 1)->Int.mod(2) == 0 ? Fast : Slow)
  )
  ->addAlreadyPracticedExercises(
    ~exerciseCount=exerciseCount - neverPracticedCount,
    ~tempo=?neverPracticedCount == 0 && topPriority
      ? None
      : neverPracticedCount->Int.mod(2) == 0
      ? Some(Slow)
      : Some(Fast),
    ~exercisesToBePracticedSlow,
    ~exercisesToBePracticedFast,
  )
  ->List.fromArray
}

let splitForSessionCalculation = (exercises: array<Exercise.Type.t>) => {
  neverPracticedTopPriorityExercises: exercises->getNeverPracticedExercises(~onlyTopPriority=true),
  topPriorityExercisesToBePracticedSlow: exercises->getExercisesToBePracticedSlow(
    ~onlyTopPriority=true,
  ),
  topPriorityExercisesToBePracticedFast: exercises->getExercisesToBePracticedFast(
    ~onlyTopPriority=true,
  ),
  neverPracticedExercises: exercises->getNeverPracticedExercises,
  exercisesToBePracticedSlow: exercises->getExercisesToBePracticedSlow,
  exercisesToBePracticedFast: exercises->getExercisesToBePracticedFast,
}

let calculateSession = (
  ~exercises: array<Exercise.Type.t>,
  ~exerciseCount,
  ~emptyResult,
  {
    neverPracticedTopPriorityExercises,
    topPriorityExercisesToBePracticedSlow,
    topPriorityExercisesToBePracticedFast,
    neverPracticedExercises,
    exercisesToBePracticedSlow,
    exercisesToBePracticedFast,
  },
) => {
  let topPriorityExercises = pickExercisesToBePracticed(
    ~neverPracticedExercises=neverPracticedTopPriorityExercises,
    ~exercisesToBePracticedSlow=topPriorityExercisesToBePracticedSlow,
    ~exercisesToBePracticedFast=topPriorityExercisesToBePracticedFast,
    ~exerciseCount=exercises->Array.filter(({topPriority}) => topPriority == true)->Array.length,
    ~topPriority=true,
  )
  let exercises = pickExercisesToBePracticed(
    ~neverPracticedExercises,
    ~exercisesToBePracticedSlow,
    ~exercisesToBePracticedFast,
    ~exerciseCount,
  )

  {...emptyResult, topPriorityExercises, exercises}
}

let dealWithOddNumber = exerciseCount =>
  exerciseCount->Int.mod(2) == 0 ? exerciseCount : exerciseCount - 1

let createSession = ({project: {exercises, name, active}, exerciseCount}) => {
  let emptyResult = {name, exercises: list{}, topPriorityExercises: list{}}

  if active {
    let exerciseCount = exerciseCount->dealWithOddNumber
    let exercises = exercises->Array.filter(({active}) => active)

    let result =
      exercises
      ->splitForSessionCalculation
      ->calculateSession(~exercises, ~exerciseCount, ~emptyResult)

    Console.log3(
      "Created practice session %s for poject %s",
      result->JSON.stringifyAnyWithIndent(2),
      name,
    )
    result
  } else {
    emptyResult
  }
}
