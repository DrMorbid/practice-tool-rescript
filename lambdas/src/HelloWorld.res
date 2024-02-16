let handler: Lambda.handler = async (~event as _, ~context as _, ~callback as _) => {
  let result: Lambda.result = {
    statusCode: 200,
    body: [("john", "doe"->JSON.Encode.string)]->Dict.fromArray->JSON.Encode.object->JSON.stringify,
  }

  result
}
