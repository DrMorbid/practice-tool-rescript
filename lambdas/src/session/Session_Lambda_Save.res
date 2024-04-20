open AWS.Lambda
open Session_Type
open Utils.Lambda

module SaveSessionBody = {
  type t = FromRequest.practiceSession
  let decode = FromRequest.practiceSession_decode
}
module Body = MakeBodyExtractor(SaveSessionBody)

module DBItem = {
  type t = storedPracticeSession
  let encode = storedPracticeSession_encode
  let tableName = Global.EnvVar.tableNameHistory
}
module DBSaver = Utils.DynamoDB.DBSaver(DBItem)

let handler: handler<'a> = async event =>
  switch event
  ->getUser
  ->Result.flatMap(userId =>
    event->Body.extract->Result.flatMap(Session_Utils.fromRequest(_, ~userId))
  )
  ->Result.map(project => project->DBSaver.save) {
  | Ok(result) => await result
  | Error(result) => result
  }
