open Util.Lambda

module DBQuery = {
  type t = Project.Type.t
  let decode = Project.Type.t_decode
  let tableName = Global.EnvVar.tableNameProjects
}
module DBQueryCaller = Util.DynamoDB.DBQueryCaller(DBQuery)

module GetAllProjectsResponse = {
  @spice
  type t = array<Project_Type.t>
  let encode = t_encode
}
module Response = MakeBodyResponder(GetAllProjectsResponse)

let handler: AWS.Lambda.handler<'a, 'b> = async event =>
  switch event
  ->getUser
  ->Result.map(async userId => {
    let dbResponse = await DBQueryCaller.query(~userId)
    Ok(dbResponse)->Response.create
  })
  ->Result.map(async result => {
    let result = await result
    switch result {
    | Ok(result) => result
    | Error(result) => result
    }
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
