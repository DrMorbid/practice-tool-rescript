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

let toProjectTableKey = (~userId, key) =>
  key->Option.map(({name}): Database.key => {
    userId,
    projectName: name,
  })
let getProjectTableKey = event =>
  event
  ->getUser
  ->Result.flatMap(userId =>
    event.pathParameters
    ->toProjectTableKey(~userId)
    ->Option.map(projectKey => Ok(projectKey))
    ->Option.getOr(
      Error({statusCode: 400, body: "Project name must be present in path parameters"}),
    )
  )

module DBKey = {
  type t = Database.key
  let tableName = Global.EnvVar.tableNameProjects
}
module DBGetter = Utils.DynamoDB.DBGetter(DBKey)
