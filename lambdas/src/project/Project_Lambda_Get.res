open Utils.Lambda
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

let handler: AWS.Lambda.handler<Project_Utils.projectNamePathParam> = async (
  ~event,
  ~context as _,
  ~callback as _,
) =>
  switch event
  ->Project_Utils.getProjectTableKey
  ->Result.map(async projectTableKey => {
    let dbItem = await projectTableKey->DBGetter.get
    Response.createResponse(~dbItem?)
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
