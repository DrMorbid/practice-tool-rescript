open Project_Type

module DBKey = {
  type t = Database.key
  let tableName = Global.EnvVar.tableNameProjects
}
module DBDeleter = Utils.DynamoDB.DBDeleter(DBKey)

let handler: AWS.Lambda.handler<projectNamePathParam> = async event =>
  switch event
  ->Project_Utils.getProjectTableKey
  ->Result.map(projectTableKey => projectTableKey->DBDeleter.delete) {
  | Ok(result) => await result
  | Error(result) => result
  }
