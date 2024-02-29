open Utils.Lambda

module SaveProjectBody = {
  type t = Project_Type.t
  type dbSaveItem = Project_Type.Database.Save.t
  let decode = Project_Type.t_decode
  let toDBSaveItem = Project_Utils.toDbSaveItem
}
module Body = MakeBodyExtractor(SaveProjectBody)

module DBItem = {
  type t = Project_Type.Database.Save.t
  let tableName = Global.EnvVar.tableNameProjects
}
module DBSaver = Utils.DynamoDB.DBSaver(DBItem)

let handler = async (~event=?, ~context as _=?, ~callback as _=?) => {
  switch getUser(~event?)
  ->Result.flatMap(userId =>
    Body.extract(~event?)->Result.flatMap(SaveProjectBody.toDBSaveItem(_, ~userId))
  )
  ->Result.map(project => project->DBSaver.save) {
  | Ok(result) => await result
  | Error(result) => result
  }
}
