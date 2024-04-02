open AWS.SDK.DynamoDB

let makeClient = () =>
  dynamoDBDocumentClient->DynamoDBDocumentClient.from(
    makeDynamoDBClient({}),
    ~translateConfig={marshallOptions: {removeUndefinedValues: true}},
  )

module type Savable = {
  type t
  let encode: t => JSON.t
  let tableName: string
}
module DBSaver = (Body: Savable) => {
  let save = async (item: Body.t): AWS.Lambda.response => {
    let put = makePutCommand({tableName: Body.tableName, item: item->Body.encode})

    Console.log3("Putting %o in DynamoDB table %s", put.input, Body.tableName)

    let result = await makeClient()->DynamoDBDocumentClient.sendPut(put)

    Console.log2("Put result is %o", result)

    {statusCode: 200, body: "Saved successfully"}
  }
}

module type Getable = {
  type key
  type t
  let decode: JSON.t => result<t, Spice.decodeError>
  let tableName: string
}
module DBGetter = (Get: Getable) => {
  let get = async (key: Get.key) => {
    let dbClient = makeClient()

    let get = makeGetCommand({tableName: Get.tableName, key})

    Console.log3("Getting %o from DynamoDB table %s", get.input, Get.tableName)

    let {?item} = await dbClient->DynamoDBDocumentClient.sendGet(get)

    item
    ->Option.map(Get.decode)
    ->Option.flatMap(item =>
      switch item {
      | Ok(item) => Some(item)
      | Error(error) => {
          Console.error2(
            "Error decoding database item from JSON to type after database GET request: %o",
            error,
          )
          None
        }
      }
    )
  }
}

module type Deletable = {
  type t
  let tableName: string
}
module DBDeleter = (Delete: Deletable) => {
  let delete = async (key: Delete.t): AWS.Lambda.response => {
    let dbClient = makeClient()

    let delete = makeDeleteCommand({tableName: Delete.tableName, key})

    Console.log3("Deleting %o from DynamoDB table %s", delete.input, Delete.tableName)

    let result = await dbClient->DynamoDBDocumentClient.sendDelete(delete)

    Console.log2("Delete result is %o", result)

    {statusCode: 200, body: "Deleted successfully"}
  }
}

module type Queryable = {
  type t
  let decode: JSON.t => result<t, Spice.decodeError>
  let tableName: string
}
module DBQueryCaller = (Query: Queryable) => {
  let query = async (~userId) => {
    let dbClient = makeClient()

    let query = makeQueryCommand({
      tableName: Query.tableName,
      keyConditionExpression: "#userId = :userId",
      expressionAttributeNames: [("#userId", "userId")]->Dict.fromArray,
      expressionAttributeValues: [(":userId", userId)]->Dict.fromArray,
    })

    Console.log3("Querying %o from DynamoDB table %s", query.input, Query.tableName)

    let {count, items} = await dbClient->DynamoDBDocumentClient.sendQuery(query)

    Console.log2("Query returned %i items", count)

    items
    ->Array.map(item =>
      switch item->Query.decode {
      | Ok(item) => Some(item)
      | Error(error) => {
          Console.error2(
            "Error decoding database item from JSON to type after database query request: %o",
            error,
          )
          None
        }
      }
    )
    ->Array.keepSome
  }
}
