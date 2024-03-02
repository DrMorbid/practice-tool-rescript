module Event = {
  type claims = {username?: string}
  type jwt = {claims?: claims}
  type authorizer = {jwt?: jwt}
  type requestContext = {authorizer?: authorizer}
  type t<'a> = {requestContext?: requestContext, body?: string, pathParameters?: 'a}
}

module Context = {
  type t = {
    functionName: string,
    functionVersion: string,
    invokedFunctionArn: string,
    memoryLimitInMB: string,
    awsRequestId: string,
    logGroupName: string,
    logStreamName: string,
  }

  @send external getRemainingTimeInMillis: (t, unit => int) => unit = "getRemainingTimeInMillis"

  @set
  external callbackWaitsForEmptyEventLoop: (t, bool) => unit = "callbackWaitsForEmptyEventLoop"
}

type callback = unit => unit

type response = {
  statusCode: int,
  headers?: Dict.t<string>,
  isBase64Encoded?: bool,
  multiValueHeaders?: Dict.t<array<string>>,
  body: string,
}

type handler<'a> = (
  ~event: Event.t<'a>,
  ~context: Context.t,
  ~callback: callback,
) => promise<response>
