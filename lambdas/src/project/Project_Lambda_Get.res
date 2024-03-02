open Utils.Lambda
open AWS.Lambda
open Project_Type

module DBKey = {
  type t = Database.key
  type result = Database.t
  let tableName = Global.EnvVar.tableNameProjects
}
module DBGetter = Utils.DynamoDB.DBGetter(DBKey)

type pathParameters = {name: string}

let handler: handler<pathParameters> = async (~event, ~context as _, ~callback as _) =>
  switch event
  ->getUser
  ->Result.flatMap(userId =>
    event.pathParameters
    ->Option.map(({name}) => Ok(
      (
        {
          userId,
          name,
        }: Database.key
      ),
    ))
    ->Option.getOr(
      Error({statusCode: 400, body: "Project name must be present in path parameters"}),
    )
  )
  ->Result.map(projectKey => projectKey->DBGetter.get) {
  | Ok(result) => await result
  | Error(result) => result
  }
