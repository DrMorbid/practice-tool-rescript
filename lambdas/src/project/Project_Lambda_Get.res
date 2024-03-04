open Utils.Lambda
open Project_Type

module DBKey = {
  type t = Database.key
  let tableName = Global.EnvVar.tableNameProjects
}
module DBGetter = Utils.DynamoDB.DBGetter(DBKey)

module GetProjectResponse = {
  type t = Database.t
  let encode = Database.t_encode
}
module Response = MakeBodyResponder(GetProjectResponse)

let handler: AWS.Lambda.handler<Project_Utils.projectNamePathParam> = async event =>
  switch event
  ->Project_Utils.getProjectTableKey
  ->Result.map(async projectTableKey => {
    let dbResponse = await projectTableKey->DBGetter.get
    Response.createResponse(~dbResponse?)
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
