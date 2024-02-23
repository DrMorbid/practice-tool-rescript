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
  id?: string,
  name?: string,
  active?: bool,
  topPriority?: bool,
  slowTempo?: string,
  fastTempo?: string,
  lastPracticed?: @spice.codec(dateCodec) Date.t,
  lastPracticedTempo?: tempoType,
}

@spice
type project = {id?: string, name?: string, active?: bool, exercises?: array<exercise>}

let handler: handler = async (~event=?, ~context as _=?, ~callback as _=?) => {
  event
  ->Option.flatMap(({?body}) => body)
  ->Option.map(JSON.parseExn)
  ->Option.map(project_decode)
  ->Option.forEach(project => {
    switch project {
    | Ok(project) => Console.log2("Lambda - Save Project - started: project=%o", project)
    | Error(error) => Console.error2("Lambda - Save Project - invalid body: error=%o", error)
    }
  })

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

  {
    statusCode: 200,
    body: [("result", "Hello World!"->JSON.Encode.string)]
    ->Dict.fromArray
    ->JSON.Encode.object
    ->JSON.stringify,
  }
}
