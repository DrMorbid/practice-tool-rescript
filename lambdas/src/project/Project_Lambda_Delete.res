open Project_Type

module DBKey = {
  type t = Database.key
  type result = Database.t
  let tableName = Global.EnvVar.tableNameProjects
}
module DBDeleter = Utils.DynamoDB.DBDeleter(DBKey)

let handler: AWS.Lambda.handler<Project_Utils.projectNamePathParam> = async (
  ~event,
  ~context as _,
  ~callback as _,
) =>
  switch event
  ->Project_Utils.getProjectTableKey
  ->Result.map(projectTableKey => projectTableKey->DBDeleter.delete) {
  | Ok(result) => await result
  | Error(result) => result
  }
