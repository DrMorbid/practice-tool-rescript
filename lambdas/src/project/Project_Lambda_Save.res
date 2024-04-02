open Utils.Lambda

module SaveProjectBody = {
  type t = Project_Type.FromRequest.t
  let decode = Project_Type.FromRequest.t_decode
}
module Body = MakeBodyExtractor(SaveProjectBody)

module DBItem = {
  type t = Project_Type.t
  let encode = Project_Type.t_encode
  let tableName = Global.EnvVar.tableNameProjects
}
module DBSaver = Utils.DynamoDB.DBSaver(DBItem)

let handler: AWS.Lambda.handler<'a> = async event =>
  switch event
  ->getUser
  ->Result.flatMap(userId =>
    event->Body.extract->Result.flatMap(Project_Utils.fromRequest(_, ~userId))
  )
  ->Result.map(project => project->DBSaver.save) {
  | Ok(result) => await result
  | Error(result) => result
  }
