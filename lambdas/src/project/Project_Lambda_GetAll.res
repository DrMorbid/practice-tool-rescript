open Utils.Lambda
open Project_Type

module DBQuery = {
  let tableName = Global.EnvVar.tableNameProjects
}
module DBQueryCaller = Utils.DynamoDB.DBQueryCaller(DBQuery)

module GetAllProjectsResponse = {
  @spice
  type t = array<Database.t>
  let encode = t_encode
}
module Response = MakeBodyResponder(GetAllProjectsResponse)

let handler: AWS.Lambda.handler<'a> = async event =>
  switch event
  ->getUser
  ->Result.map(async userId => {
    let dbResponse = await DBQueryCaller.query(~userId)
    Response.createResponse(~dbResponse)
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
