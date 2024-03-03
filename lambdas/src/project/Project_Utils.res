open AWS.Lambda
open Project_Type
open Utils.Lambda

let toDBSaveItem = (~userId, {?projectName, ?active, exercises: ?inputExercises}): result<
  Database.t,
  response,
> => {
  let exercises =
    inputExercises->Option.getOr([])->Array.map(Exercise.Utils.toDBSaveItem)->Array.keepSome

  if exercises->Array.length < inputExercises->Option.getOr([])->Array.length {
    Error({statusCode: 400, body: "Exercise name cannot be empty"})
  } else {
    projectName
    ->Utils.String.toNotBlank
    ->Option.map((projectName): result<Database.t, 'a> => Ok({
      userId,
      projectName,
      active: active->Option.getOr(false),
      exercises,
    }))
    ->Option.getOr(Error({statusCode: 400, body: "Project name cannot be empty"}))
  }
}

let toDBGetItem = (~userId, projectName): result<Database.key, response> => Ok({
  userId,
  projectName,
})

type projectNamePathParam = {name: string}
let toProjectTableKey = (~userId, key) =>
  key->Option.map(({name}) => Ok(
    (
      {
        userId,
        projectName: name,
      }: Database.key
    ),
  ))
let getProjectTableKey = (~key=?, event) =>
  event
  ->getUser
  ->Result.flatMap(userId =>
    key
    ->toProjectTableKey(~userId)
    ->Option.getOr(
      event.pathParameters
      ->toProjectTableKey(~userId)
      ->Option.getOr(
        Error({statusCode: 400, body: "Project name must be present in path parameters"}),
      ),
    )
  )
