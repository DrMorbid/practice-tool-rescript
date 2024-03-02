open Utils.Lambda
open AWS.Lambda
open Project_Type

module DBKey = {
  type t = Database.key
  type result = Database.t
  let tableName = Global.EnvVar.tableNameProjects
}
module DBGetter = Utils.DynamoDB.DBGetter(DBKey)

module GetProjectResponse = {
  type t = Database.t
  let encode = Database.t_encode
}
module Response = MakeBodyResponder(GetProjectResponse)

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
  ->Result.map(async projectKey => {
    let dbItem = await projectKey->DBGetter.get
    Response.createResponse(~dbItem?)
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
