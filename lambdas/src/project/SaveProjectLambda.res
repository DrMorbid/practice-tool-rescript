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
type lastPracticed = {
  date?: @spice.codec(dateCodec) Date.t,
  tempo?: tempoType,
}

@spice
type exercise = {
  name?: string,
  active?: bool,
  topPriority?: bool,
  slowTempo?: string,
  fastTempo?: string,
  lastPracticed?: lastPracticed,
}

@spice
type project = {
  userId?: string,
  name?: string,
  active?: bool,
  exercises?: array<exercise>,
}

type lastPracticedDbSaveItem = {
  date: string,
  tempo: string,
}

type exerciseDbSaveItem = {
  name: string,
  active: bool,
  topPriority: bool,
  slowTempo: string,
  fastTempo: string,
  lastPracticed?: lastPracticedDbSaveItem,
}

type projectDbSaveItem = {
  @as("user-id") userId: string,
  name: string,
  active: bool,
  exercises: array<exerciseDbSaveItem>,
}

let toNotBlank = value =>
  value
  ->Option.map(String.trim)
  ->Option.filter(name => name->String.length > 0)

let exerciseToDbSaveItem = (exercise: exercise) =>
  exercise.name
  ->toNotBlank
  ->Option.map(name => {
    name,
    active: exercise.active->Option.getOr(false),
    topPriority: exercise.topPriority->Option.getOr(false),
    slowTempo: exercise.slowTempo->Option.getOr(Exercise.Constant.defaultSlowTempo),
    fastTempo: exercise.fastTempo->Option.getOr(Exercise.Constant.defaultFastTempo),
    lastPracticed: ?exercise.lastPracticed->Option.flatMap(({?date, ?tempo}) =>
      switch (date, tempo->Option.map(tempoType_encode)->Option.flatMap(JSON.Decode.string)) {
      | (Some(date), Some(tempo)) => Some({date: date->Date.toISOString, tempo})
      | _ => None
      }
    ),
  })

let toDbSaveItem = (~userId, {?name, ?active, exercises: ?inputExercises}: project) => {
  let exercises = inputExercises->Option.getOr([])->Array.map(exerciseToDbSaveItem)->Array.keepSome

  if exercises->Array.length < inputExercises->Option.getOr([])->Array.length {
    Error({statusCode: 400, body: "Exercise name cannot be empty"})
  } else {
    name
    ->toNotBlank
    ->Option.map(name => Ok({
      userId,
      name,
      active: active->Option.getOr(false),
      exercises,
    }))
    ->Option.getOr(Error({statusCode: 400, body: "Project name cannot be empty"}))
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
    ->Result.flatMap(project => project->toDbSaveItem(~userId))
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
