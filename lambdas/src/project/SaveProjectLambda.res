open AWS.Lambda

let dateEncoder = date => date->Date.toISOString->JSON.Encode.string

let dateDecoder = date => {
  let result = date->JSON.Decode.string->Option.map(Date.fromString)

  switch result {
  | Some(result) if result->Date.toString == "Invalid Date" =>
    Error({
      Spice.path: "",
      message: "The date is invalid",
      value: date,
    })
  | Some(result) => Ok(result)
  | None =>
    Error({
      Spice.path: "",
      message: "The date is not a string",
      value: date,
    })
  }
}

let dateCodec: Spice.codec<Date.t> = (dateEncoder, dateDecoder)

@spice
type tempoType = | @spice.as("SLOW") Slow | @spice.as("FAST") Fast

@spice
type exercise = {
  name?: string,
  active?: bool,
  topPriority?: bool,
  slowTempo?: string,
  fastTempo?: string,
  lastPracticed?: @spice.codec(dateCodec) Date.t,
  lastPracticedTempo?: tempoType,
}

@spice
type project = {
  @as("user-id") userId?: string,
  name?: string,
  active?: bool,
  exercises?: array<exercise>,
}

let isBlank = value =>
  value
  ->Option.map(String.trim)
  ->Option.filter(name => name->String.length > 0)
  ->Option.isNone

let validateProject = project => {
  if project.name->isBlank {
    Error({statusCode: 400, body: "Project name cannot be empty"})
  } else if (
    project.exercises
    ->Option.flatMap(exercises => exercises->Array.find(exercise => exercise.name->isBlank))
    ->Option.isSome
  ) {
    Error({statusCode: 400, body: "Exercise name cannot be empty"})
  } else {
    Ok(project)
  }
}

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
    ->Option.map(project_decode)
    ->Option.map(project => {
      project->Result.mapError(
        error => {
          Console.error2("Invalid request body: %o", error)
          {statusCode: 400, body: "Invalid request body"}
        },
      )
    })
    ->Option.getOr(Error({statusCode: 400, body: "No request body"}))
    ->Result.flatMap(validateProject)
    ->Result.map(project => {
      ...project,
      userId,
    })
  )
  ->Result.map(project => {
    let client = AWS.SDK.DynamoDB.makeDynamoDBClient({})
    let docClient =
      AWS.SDK.DynamoDB.dynamoDBDocumentClient->AWS.SDK.DynamoDB.DynamoDBDocumentClient.from(client)

    let put = AWS.SDK.DynamoDB.makePutCommand({
      tableName: EnvVar.tableNameProjects,
      item: project,
    })

    Console.log3("Putting %o in DynamoDB table %s", put.input, EnvVar.tableNameProjects)

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
