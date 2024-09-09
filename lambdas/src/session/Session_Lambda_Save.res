open AWS.Lambda
open Session_Type
open Util.Lambda
open Session_Util

module SaveSessionBody = {
  type t = FromRequest.practiceSession
  let decode = FromRequest.practiceSession_decode
}
module Body = MakeBodyExtractor(SaveSessionBody)

module DBProjectItem = {
  type t = Project.Type.t
  let encode = Project.Type.t_encode
  let tableName = Global.EnvVar.tableNameProjects
}
module DBProjectSaver = Util.DynamoDB.DBSaver(DBProjectItem)

module DBHistoryItem = {
  type t = historyItem
  let encode = historyItem_encode
  let tableName = Global.EnvVar.tableNameHistory
}
module DBHistorySaver = Util.DynamoDB.DBSaver(DBHistoryItem)

let handler: handler<'a> = async event =>
  switch event
  ->getUser
  ->Result.flatMap(userId =>
    event
    ->Body.extract
    ->Result.flatMap(fromRequest(_, ~userId))
    ->toSaveSessionWrapper(~userId)
  )
  ->Result.map(async ({projects, historyItem}) => {
    let projectsSaveResults =
      await projects.projects->updateProjects(
        ~userId=projects.userId,
        ~saveToDb=DBProjectSaver.save,
      )

    switch projectsSaveResults->Array.find(isNotOk) {
    | Some(projectsSaveResults) => projectsSaveResults
    | None => await historyItem->DBHistorySaver.save
    }
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
