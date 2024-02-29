open AWS.Lambda

let getUser = (~event: option<Event.t>=?) =>
  event
  ->Option.flatMap(({?requestContext}) => requestContext)
  ->Option.flatMap(({?authorizer}) => authorizer)
  ->Option.flatMap(({?jwt}) => jwt)
  ->Option.flatMap(({?claims}) => claims)
  ->Option.flatMap(({?username}) => username)
  ->Option.map(username => Ok(username))
  ->Option.getOr(Error({statusCode: 403, body: "No authenticated user"}))

module type Extractable = {
  type t
  type dbSaveItem
  let decode: JSON.t => result<t, Spice.decodeError>
  let toDBSaveItem: (~userId: string, t) => result<dbSaveItem, response>
}

module MakeBodyExtractor = (Body: Extractable) => {
  let extract = (~event: option<Event.t>=?) =>
    event
    ->Option.flatMap(({?body}) => body)
    ->Option.map(JSON.parseExn)
    ->Option.map(Body.decode)
    ->Option.map(extracted => {
      extracted->Result.mapError(error => {
        Console.error2("Invalid request body: %o", error)
        {statusCode: 400, body: "Invalid request body"}
      })
    })
    ->Option.getOr(Error({statusCode: 400, body: "No request body"}))
}
