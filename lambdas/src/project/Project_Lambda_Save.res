open Utils.Lambda

module SaveProjectBody = {
  type t = Project_Type.t
  type dbRequest = Project_Type.Database.Save.t
  let decode = Project_Type.t_decode
  let toDBRequest = Project_Utils.toDBSaveItem
}
module Body = MakeBodyExtractor(SaveProjectBody)

module DBItem = {
  type t = Project_Type.Database.Save.t
  let tableName = Global.EnvVar.tableNameProjects
}
module DBSaver = Utils.DynamoDB.DBSaver(DBItem)

let handler: AWS.Lambda.handler = async (~event=?, ~context as _=?, ~callback as _=?) =>
  switch getUser(~event?)
  ->Result.flatMap(userId =>
    Body.extract(~event?)->Result.flatMap(SaveProjectBody.toDBRequest(_, ~userId))
  )
  ->Result.map(project => project->DBSaver.save) {
  | Ok(result) => await result
  | Error(result) => result
  }
