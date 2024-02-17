let cognito = AWS.SDK.cognitoIdentityServiceProvider()

let handler: AWS.Lambda.handler = async (~event as _, ~context as _, ~callback as _) => {
  let result: AWS.Lambda.result = {
    statusCode: 200,
    body: [("john", "doe"->JSON.Encode.string)]->Dict.fromArray->JSON.Encode.object->JSON.stringify,
  }

  result
}
