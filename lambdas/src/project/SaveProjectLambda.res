open AWS.Lambda

@spice
type body = {john?: string}

let handler: handler = async (~event=?, ~context as _=?, ~callback as _=?) => {
  event
  ->Option.flatMap(({?body}) => body)
  ->Option.map(JSON.parseExn)
  ->Option.map(body_decode)
  ->Option.forEach(body => {
    switch body {
    | Ok(body) => Console.log2("Lambda - Save Project - started: body=%o", body)
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
