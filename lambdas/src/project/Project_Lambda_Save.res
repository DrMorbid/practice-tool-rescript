open Utils.Lambda

module SaveProjectBody = {
  type t = Project_Type.t
  type dbRequest = Project_Type.Database.t
  let decode = Project_Type.t_decode
  let toDBRequest = Project_Utils.toDBSaveItem
}
module Body = MakeBodyExtractor(SaveProjectBody)

module DBItem = {
  type t = Project_Type.Database.t
  let tableName = Global.EnvVar.tableNameProjects
}
module DBSaver = Utils.DynamoDB.DBSaver(DBItem)

let handler: AWS.Lambda.handler<'a> = async (~event, ~context as _, ~callback as _) =>
  switch event
  ->getUser
  ->Result.flatMap(userId =>
    event->Body.extract->Result.flatMap(SaveProjectBody.toDBRequest(_, ~userId))
  )
  ->Result.map(project => project->DBSaver.save) {
  | Ok(result) => await result
  | Error(result) => result
  }
