open AWS.Lambda

let handler: handler = async (~event as _=?, ~context as _=?, ~callback as _=?) => {
  {
    statusCode: 200,
    body: [("result", JSON.Encode.string("Hello World!"))]
    ->Js.Dict.fromArray
    ->JSON.Encode.object
    ->JSON.stringify,
  }
}
