open AWS.Lambda

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

  {
    statusCode: 200,
    body: [("result", "Hello World!"->JSON.Encode.string)]
    ->Dict.fromArray
    ->JSON.Encode.object
    ->JSON.stringify,
  }
}
