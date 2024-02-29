open Utils.Lambda

module GetProjectBody = {
  type t = string
  type dbRequest = Project_Type.Database.Get.t
  let decode = Spice.stringFromJson
  let toDBRequest = Project_Utils.toDBGetItem
}
module Body = MakeBodyExtractor(GetProjectBody)

module DBKey = {
  type t = Project_Type.Database.Get.t
  let tableName = Global.EnvVar.tableNameProjects
}
module DBGetter = Utils.DynamoDB.DBGetter(DBKey)

let handler: AWS.Lambda.handler = async (~event=?, ~context as _=?, ~callback as _=?) =>
  switch getUser(~event?)
  ->Result.flatMap(userId =>
    Body.extract(~event?)->Result.flatMap(GetProjectBody.toDBRequest(_, ~userId))
  )
  ->Result.map(project => project->DBGetter.get) {
  | Ok(result) => await result
  | Error(result) => result
  }
