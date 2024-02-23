open AWS.Lambda

let handler: handler = async (~event=?, ~context as _=?, ~callback as _=?) => {
  Console.log2("Lambda - Save Project - started: event=%o", event)

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

  event
  ->Option.flatMap(({?body}) => body)
  ->Option.map(JSON.parseExn)
  ->Option.flatMap(JSON.Decode.object)
  ->Option.flatMap(Dict.get(_, "john"))
  ->Option.flatMap(JSON.Decode.string)
  ->Option.forEach(john => Console.log2("John is %s", john))

  {
    statusCode: 200,
    body: [("result", "Hello World!"->JSON.Encode.string)]
    ->Dict.fromArray
    ->JSON.Encode.object
    ->JSON.stringify,
  }
}
