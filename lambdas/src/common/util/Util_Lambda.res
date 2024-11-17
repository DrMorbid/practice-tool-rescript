open AWS.Lambda

let defaultResponseHeaders =
  [
    ("Access-Control-Allow-Origin", "*"),
    ("Access-Control-Allow-Credentials", true->string_of_bool),
  ]->Dict.fromArray

let getUser = ({?requestContext}: Event.t<'a, 'b>) =>
  requestContext
  ->Option.flatMap(({?authorizer}) => authorizer)
  ->Option.flatMap(({?jwt}) => jwt)
  ->Option.flatMap(({?claims}) => claims)
  ->Option.flatMap(({?username}) => username)
  ->Option.map(username => Ok(username))
  ->Option.getOr(
    Error({statusCode: 403, headers: defaultResponseHeaders, body: "No authenticated user"}),
  )

let getUserAndQueryParams = (~decode, event: Event.t<'a, 'b>) => {
  let user = event->getUser
  let queryParams = event.queryStringParameters->Option.map(decode)

  switch (user, queryParams) {
  | (Ok(userId), Some(Ok(queryParams))) => Ok((userId, Some(queryParams)))
  | (Ok(userId), None) => Ok((userId, None))
  | (_, Some(Error(error: Spice.decodeError))) =>
    Error({statusCode: 400, headers: defaultResponseHeaders, body: error.message})
  | (Error(error), _) => Error(error)
  }
}

module type Extractable = {
  type t
  let decode: JSON.t => result<t, Spice.decodeError>
}
module MakeBodyExtractor = (Body: Extractable) => {
  let extract = ({?body}: Event.t<'a, 'b>) =>
    body
    ->Option.map(JSON.parseExn(_))
    ->Option.map(Body.decode)
    ->Option.map(extracted => {
      extracted->Result.mapError(error => {
        Console.error2("Invalid request body: %o", error)
        {statusCode: 400, headers: defaultResponseHeaders, body: "Invalid request body"}
      })
    })
    ->Option.getOr(
      Error({statusCode: 400, headers: defaultResponseHeaders, body: "No request body"}),
    )
}

module type Respondable = {
  type t
  let encode: t => JSON.t
}
module MakeBodyResponder = (Body: Respondable) => {
  let create = response =>
    response
    ->Result.map(Body.encode)
    ->Result.map(bodyEncoded => {
      statusCode: 200,
      headers: defaultResponseHeaders,
      body: bodyEncoded->JSON.stringify,
    })
}

let isOk = ({statusCode}) => statusCode >= 200 && statusCode < 300
let isNotOk = response => !(response->isOk)
