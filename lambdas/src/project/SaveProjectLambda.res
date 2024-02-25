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
type project = {name?: string, active?: bool, exercises?: array<exercise>}

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
    Ok("Project is valid")
  }
}

let handler: handler = async (~event=?, ~context as _=?, ~callback as _=?) => {
  Console.log2(
    "Hello, user with ID %s",
    event
    ->Option.flatMap(({?requestContext}) => requestContext)
    ->Option.flatMap(({?authorizer}) => authorizer)
    ->Option.flatMap(({?jwt}) => jwt)
    ->Option.flatMap(({?claims}) => claims)
    ->Option.flatMap(({?username}) => username)
    ->Option.getOr(""),
  )

  switch event
  ->Option.flatMap(({?body}) => body)
  ->Option.map(JSON.parseExn)
  ->Option.map(project_decode)
  ->Option.map(project => {
    project->Result.mapError(error => {
      Console.error2("Invalid request body: %o", error)
      {statusCode: 400, body: "Invalid request body"}
    })
  })
  ->Option.getOr(Error({statusCode: 400, body: "No request body"}))
  ->Result.flatMap(validateProject)
  ->Result.map(body => {statusCode: 200, body}) {
  | Ok(result) => result
  | Error(result) => result
  }
}
