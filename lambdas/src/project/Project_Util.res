open AWS.Lambda
open Util.Lambda

let fromRequest = (
  ~userId,
  {?name, ?originalName, ?active, exercises: ?inputExercises}: Project_Type.FromRequest.t,
): result<(Project_Type.t, option<string>), response> => {
  let exercises =
    inputExercises->Option.getOr([])->Array.map(Exercise.Util.fromRequest)->Array.keepSome

  if exercises->Array.length < inputExercises->Option.getOr([])->Array.length {
    Error({
      statusCode: 400,
      headers: Util.Lambda.defaultResponseHeaders,
      body: "Exercise name cannot be empty",
    })
  } else {
    name
    ->Util.String.toNotBlank
    ->Option.map((name): result<(Project_Type.t, option<string>), 'a> => Ok((
      {
        userId,
        name,
        active: active->Option.getOr(false),
        exercises,
      },
      originalName,
    )))
    ->Option.getOr(
      Error({
        statusCode: 400,
        headers: Util.Lambda.defaultResponseHeaders,
        body: "Project name cannot be empty",
      }),
    )
  }
}

let toProjectTableKey = (
  ~userId,
  {name}: Project_Type.projectNamePathParam,
): Project_Type.dbKey => {
  userId,
  name,
}

let optionToProjectTableKey = (~userId, key) => key->Option.map(toProjectTableKey(_, ~userId))

let getProjectTableKey = event =>
  event
  ->getUser
  ->Result.flatMap(userId =>
    event.pathParameters
    ->optionToProjectTableKey(~userId)
    ->Option.map(projectKey => Ok(projectKey))
    ->Option.getOr(
      Error({
        statusCode: 400,
        headers: Util.Lambda.defaultResponseHeaders,
        body: "Project name must be present in path parameters",
      }),
    )
  )

module DBKey = {
  type key = Project_Type.dbKey
  type t = Project_Type.t
  let encodeKey = Project_Type.dbKey_encode
  let decode = Project_Type.t_decode
  let tableName = Global.EnvVar.tableNameProjects
}
module DBGetter = Util.DynamoDB.DBGetter(DBKey)
