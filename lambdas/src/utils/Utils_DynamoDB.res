open AWS.SDK.DynamoDB

let makeClient = () =>
  dynamoDBDocumentClient->DynamoDBDocumentClient.from(
    makeDynamoDBClient({}),
    ~translateConfig={marshallOptions: {removeUndefinedValues: true}},
  )

module type Savable = {
  type t
  let tableName: string
}
module DBSaver = (Body: Savable) => {
  let save = async (item: Body.t): AWS.Lambda.response => {
    let put = makePutCommand({tableName: Body.tableName, item})

    Console.log3("Putting %o in DynamoDB table %s", put.input, Body.tableName)

    let result = await makeClient()->DynamoDBDocumentClient.sendPut(put)

    Console.log2("Put result is %o", result)

    {statusCode: 200, body: "Saved successfully"}
  }
}

module type Getable = {
  type t
  let tableName: string
}
module DBGetter = (Body: Getable) => {
  let get = async (key: Body.t): AWS.Lambda.response => {
    let dbClient = makeClient()

    let get = makeGetCommand({tableName: Body.tableName, key})

    Console.log3("Getting %o from DynamoDB table %s", get.input, Body.tableName)

    let result = await dbClient->DynamoDBDocumentClient.sendGet(get)

    Console.log2("Get result is %o", result)

    {statusCode: 200, body: "Fetched successfully"}
  }
}
