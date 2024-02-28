open AWS.Lambda

let handler: handler = async (~event=?, ~context as _=?, ~callback as _=?) => {
  switch event
  ->Option.flatMap(({?requestContext}) => requestContext)
  ->Option.flatMap(({?authorizer}) => authorizer)
  ->Option.flatMap(({?jwt}) => jwt)
  ->Option.flatMap(({?claims}) => claims)
  ->Option.flatMap(({?username}) => username)
  ->Option.map(username => Ok(username))
  ->Option.getOr(Error({statusCode: 403, body: "No authenticated user"}))
  ->Result.flatMap(userId =>
    event
    ->Option.flatMap(({?body}) => body)
    ->Option.map(JSON.parseExn)
    ->Option.map(Project_Type.t_decode)
    ->Option.map(project => {
      project->Result.mapError(
        error => {
          Console.error2("Invalid request body: %o", error)
          {statusCode: 400, body: "Invalid request body"}
        },
      )
    })
    ->Option.getOr(Error({statusCode: 400, body: "No request body"}))
    ->Result.flatMap(project => project->Project_Utils.toDbSaveItem(~userId))
  )
  ->Result.map(project => {
    let client = AWS.SDK.DynamoDB.makeDynamoDBClient({})
    let docClient =
      AWS.SDK.DynamoDB.dynamoDBDocumentClient->AWS.SDK.DynamoDB.DynamoDBDocumentClient.from(
        client,
        ~translateConfig={marshallOptions: {removeUndefinedValues: true}},
      )

    let put = AWS.SDK.DynamoDB.makePutCommand({
      tableName: Global.EnvVar.tableNameProjects,
      item: project,
    })

    Console.log3("Putting %o in DynamoDB table %s", put.input, Global.EnvVar.tableNameProjects)

    docClient->AWS.SDK.DynamoDB.DynamoDBDocumentClient.sendPut(put)
  })
  ->Result.map(result =>
    result->Promise.thenResolve(result => {
      Console.log2("Put result is %o", result)

      {statusCode: 200, body: "Saved successfully"}
    })
  ) {
  | Ok(result) => await result
  | Error(result) => result
  }
}
