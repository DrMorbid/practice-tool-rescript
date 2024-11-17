open Util.Lambda

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
module DBSaver = Util.DynamoDB.DBSaver(DBItem)

module DBKey = {
  type t = Project_Type.dbKey
  let encode = Project_Type.dbKey_encode
  let tableName = Global.EnvVar.tableNameProjects
}
module DBDeleter = Util.DynamoDB.DBDeleter(DBKey)

let handler: AWS.Lambda.handler<'a, 'b> = async event =>
  switch event
  ->getUser
  ->Result.flatMap(userId =>
    event->Body.extract->Result.flatMap(Project_Util.fromRequest(_, ~userId))
  )
  ->Result.map(async ((project, originalName)) => {
    let saveResult = await project->DBSaver.save

    switch originalName {
    | Some(name) if project.name != name => {
        let _ = await {userId: project.userId, name}->DBDeleter.delete
        saveResult
      }
    | Some(_) | None => saveResult
    }
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
