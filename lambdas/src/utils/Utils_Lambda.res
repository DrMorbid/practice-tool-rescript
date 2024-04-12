open AWS.Lambda

let getUser = ({?requestContext}: Event.t<'a>) =>
  requestContext
  ->Option.flatMap(({?authorizer}) => authorizer)
  ->Option.flatMap(({?jwt}) => jwt)
  ->Option.flatMap(({?claims}) => claims)
  ->Option.flatMap(({?username}) => username)
  ->Option.map(username => Ok(username))
  ->Option.getOr(Error({statusCode: 403, body: "No authenticated user"}))

module type Extractable = {
  type t
  let decode: JSON.t => result<t, Spice.decodeError>
}
module MakeBodyExtractor = (Body: Extractable) => {
  let extract = ({?body}: Event.t<'a>) =>
    body
    ->Option.map(JSON.parseExn(_))
    ->Option.map(Body.decode)
    ->Option.map(extracted => {
      extracted->Result.mapError(error => {
        Console.error2("Invalid request body: %o", error)
        {statusCode: 400, body: "Invalid request body"}
      })
    })
    ->Option.getOr(Error({statusCode: 400, body: "No request body"}))
}

module type Respondable = {
  type t
  let encode: t => JSON.t
}
module MakeBodyResponder = (Body: Respondable) => {
  let create = response =>
    response
    ->Result.map(Body.encode)
    ->Result.map(bodyEncoded => {statusCode: 200, body: bodyEncoded->JSON.stringify})
}
