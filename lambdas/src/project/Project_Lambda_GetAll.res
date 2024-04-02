open Utils.Lambda

module DBQuery = {
  type t = Project.Type.t
  let decode = Project.Type.t_decode
  let tableName = Global.EnvVar.tableNameProjects
}
module DBQueryCaller = Utils.DynamoDB.DBQueryCaller(DBQuery)

module GetAllProjectsResponse = {
  @spice
  type t = array<Project_Type.t>
  let encode = t_encode
}
module Response = MakeBodyResponder(GetAllProjectsResponse)

let handler: AWS.Lambda.handler<'a> = async event =>
  switch event
  ->getUser
  ->Result.map(async userId => {
    let dbResponse = await DBQueryCaller.query(~userId)
    Some(dbResponse)->Response.create
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
