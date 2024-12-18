open AWS.Lambda
open Util.Lambda
open Session_Type
open Exercise.Util

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
    ->Option.map(({projectName, exerciseCount}) => {
      projectTableKey: {name: projectName}->Project.Util.toProjectTableKey(~userId),
      exerciseCount,
    })
    ->Option.map(practiceSessionRequest => Ok(practiceSessionRequest))
    ->Option.getOr(
      Error({
        statusCode: 400,
        headers: Util.Lambda.defaultResponseHeaders,
        body: "Project name must be present in path parameters",
      }),
    )
  )

let validateSessionConfiguration = (~exerciseCount, project: Project.Type.t) => {
  (
    project.active
      ? Ok(project)
      : Error({
          statusCode: 400,
          headers: Util.Lambda.defaultResponseHeaders,
          body: "Project is not active",
        })
  )->Result.flatMap(project => {
    let activeTopPriorityExercises =
      project.exercises->Array.filter(({active, topPriority}) => active && topPriority)
    let activeExercises =
      project.exercises->Array.filter(({active, topPriority}) => active && !topPriority)

    if (
      activeTopPriorityExercises->Array.length > 0 || activeExercises->Array.length >= exerciseCount
    ) {
      Ok(project)
    } else {
      Error({
        statusCode: 400,
        headers: Util.Lambda.defaultResponseHeaders,
        body: "Project does not have enough active exercises",
      })
    }
  })
}

let rec addAlreadyPracticedExercises = (
  ~tempo=?,
  ~exerciseCount,
  ~exercisesToBePracticedSlow,
  ~exercisesToBePracticedFast,
  result,
) => {
  Console.debug2(
    "The requester number of exercises already practiced in the past to be added is %i",
    exerciseCount,
  )

  if (
    exerciseCount == 0 ||
      (exercisesToBePracticedSlow->List.length == 0 && exercisesToBePracticedFast->List.length == 0)
  ) {
    Console.debug2(
      "Added all the exercises already practiced in the past. The result is %o",
      result,
    )
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
  let neverPracticedExercises = neverPracticedExercises->Array.slice(~start=0, ~end=exerciseCount)
  let neverPracticedCount = neverPracticedExercises->Array.length

  neverPracticedExercises
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
  Console.debug("Calculating top priority exercises.")
  let topPriorityExercises = pickExercisesToBePracticed(
    ~neverPracticedExercises=neverPracticedTopPriorityExercises,
    ~exercisesToBePracticedSlow=topPriorityExercisesToBePracticedSlow,
    ~exercisesToBePracticedFast=topPriorityExercisesToBePracticedFast,
    ~exerciseCount=exercises->Array.filter(({topPriority}) => topPriority == true)->Array.length,
    ~topPriority=true,
  )

  Console.debug2("Calculating normal exercises with desired count being %i.", exerciseCount)
  let exercises = pickExercisesToBePracticed(
    ~neverPracticedExercises,
    ~exercisesToBePracticedSlow,
    ~exercisesToBePracticedFast,
    ~exerciseCount,
  )

  {...emptyResult, topPriorityExercises, exercises}
}

let normalize = (~exercises: array<Exercise.Type.t>, exerciseCount) => {
  let exerciseCount = exerciseCount->Int.mod(2) == 0 ? exerciseCount : exerciseCount - 1
  let nrOfActiveExercises = exercises->Array.filter(({topPriority}) => !topPriority)->Array.length
  exerciseCount > nrOfActiveExercises && exerciseCount - nrOfActiveExercises <= 1
    ? 0
    : exerciseCount
}

let createSession = ({project: {exercises, name, active}, exerciseCount}) => {
  let emptyResult = {name, exercises: list{}, topPriorityExercises: list{}}

  if active {
    let exercises = exercises->Array.filter(({active}) => active)
    let exerciseCount = exerciseCount->normalize(~exercises)

    let result =
      exercises
      ->splitForSessionCalculation
      ->calculateSession(~exercises, ~exerciseCount, ~emptyResult)

    Console.log3(
      "Created practice session %s for poject %s",
      result->JSON.stringifyAny(~space=2),
      name,
    )
    result
  } else {
    emptyResult
  }
}

let fromRequest = (~userId, practiceSession: FromRequest.practiceSession): result<
  historyItem,
  response,
> => {
  let exercises =
    practiceSession
    ->Array.flatMap(({?name, exercises}) => exercises->Array.map(exercise => (name, exercise)))
    ->Array.map(((projectName, exercise)) => exercise->fromSessionRequest(~projectName?))

  switch (exercises, exercises->Array.find(Result.isError)) {
  | ([], _) =>
    Error({
      statusCode: 400,
      headers: Util.Lambda.defaultResponseHeaders,
      body: "At least one exercise must have been practiced",
    })
  | (_, Some(Error(exerciseError))) => Error(exerciseError)
  | _ =>
    Ok({
      userId,
      date: Date.make(),
      exercises: exercises->Array.filterMap(exercise =>
        exercise->Result.map(exercise => Some(exercise))->Result.getOr(None)
      ),
    })
  }
}

let toSaveSessionWrapper = (~userId, historyItem) =>
  historyItem->Result.map((historyItem: historyItem) => {
    projects: historyItem.exercises->Array.reduce({userId, projects: []}, (
      result,
      {name: exerciseName, projectName, tempo},
    ) => {
      ...result,
      projects: result.projects
      ->Array.filter(({name}) => name != projectName)
      ->Array.concat([
        result.projects
        ->Array.findMap(
          ({name, exercises}) =>
            name == projectName
              ? Some({
                  name,
                  exercises: exercises->Array.concat([
                    {
                      name: exerciseName,
                      lastPracticed: {date: historyItem.date, tempo},
                    },
                  ]),
                })
              : None,
        )
        ->Option.getOr({
          name: projectName,
          exercises: [{name: exerciseName, lastPracticed: {date: historyItem.date, tempo}}],
        }),
      ]),
    }),
    historyItem,
  })

let updateProjects = async (~userId, ~saveToDb, projects) =>
  await projects
  ->Array.map(async project => {
    let projectDBResponse =
      await {name: project.name}
      ->Project.Util.toProjectTableKey(~userId)
      ->Project.Util.DBGetter.get

    await (
      switch projectDBResponse->Result.map(projectFromDB => {
        ...projectFromDB,
        exercises: projectFromDB.exercises->Array.map(
          exerciseFromDB => {
            ...exerciseFromDB,
            lastPracticed: ?(
              project.exercises
              ->Array.find(exercise => exercise.name == exerciseFromDB.name)
              ->Option.map(exercise => exercise.lastPracticed)
              ->Option.orElse(exerciseFromDB.lastPracticed)
            ),
          },
        ),
      }) {
      | Ok(project) => project->saveToDb
      | Error(error) => Promise.resolve(error)
      }
    )
  })
  ->Promise.all
