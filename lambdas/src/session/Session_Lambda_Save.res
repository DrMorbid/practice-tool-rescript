open AWS.Lambda
open Session_Type
open Utils.Lambda

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
module DBProjectSaver = Utils.DynamoDB.DBSaver(DBProjectItem)

module DBHistoryItem = {
  type t = historyItem
  let encode = historyItem_encode
  let tableName = Global.EnvVar.tableNameHistory
}
module DBHistorySaver = Utils.DynamoDB.DBSaver(DBHistoryItem)

let handler: handler<'a> = async event =>
  switch event
  ->getUser
  ->Result.flatMap(userId =>
    event
    ->Body.extract
    ->Result.flatMap(Session_Utils.fromRequest(_, ~userId))
    ->Session_Utils.toSaveSessionWrapper(~userId)
  )
  ->Result.map(async ({projects, historyItem}) => {
    let projectSaveResults =
      await projects.projects
      ->Array.map(async project => {
        let projectDBResponse =
          await {name: project.name}
          ->Project.Utils.toProjectTableKey(~userId=projects.userId)
          ->Project.Utils.DBGetter.get

        await (
          switch projectDBResponse->Result.map(
            projectFromDB => {
              ...projectFromDB,
              exercises: projectFromDB.exercises->Array.map(
                exerciseFromDB => {
                  ...exerciseFromDB,
                  lastPracticed: ?(
                    project.exercises
                    ->Array.find(exercise => exercise.name == exerciseFromDB.name)
                    ->Option.map(exercise => exercise.lastPracticed)
                  ),
                },
              ),
            },
          ) {
          | Ok(project) => project->DBProjectSaver.save
          | Error(error) => Promise.resolve(error)
          }
        )
      })
      ->Promise.all

    switch projectSaveResults->Array.find(isNotOk) {
    | Some(projectSaveResult) => projectSaveResult
    | None => await historyItem->DBHistorySaver.save
    }
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
