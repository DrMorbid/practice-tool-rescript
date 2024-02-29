open AWS.SDK.DynamoDB

module type Savable = {
  type t
  let tableName: string
}

module DBSaver = (Body: Savable) => {
  let save = async (item: Body.t): AWS.Lambda.response => {
    let dbClient =
      dynamoDBDocumentClient->DynamoDBDocumentClient.from(
        makeDynamoDBClient({}),
        ~translateConfig={marshallOptions: {removeUndefinedValues: true}},
      )

    let put = makePutCommand({tableName: Body.tableName, item})

    Console.log3("Putting %o in DynamoDB table %s", put.input, Body.tableName)

    let result = await dbClient->DynamoDBDocumentClient.sendPut(put)

    Console.log2("Put result is %o", result)

    {statusCode: 200, body: "Saved successfully"}
  }
}
