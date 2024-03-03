open Utils.Lambda

module DBQuery = {
  let tableName = Global.EnvVar.tableNameProjects
}
module DBQueryCaller = Utils.DynamoDB.DBQueryCaller(DBQuery)

let handler: AWS.Lambda.handler<'a> = async event =>
  switch event
  ->getUser
  ->Result.map(async userId => {
    let queryResult = await DBQueryCaller.query(~userId)
    Console.log2("Got all projects from DB: %o", queryResult)
    ({statusCode: 200, body: "All good"}: AWS.Lambda.response)
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
