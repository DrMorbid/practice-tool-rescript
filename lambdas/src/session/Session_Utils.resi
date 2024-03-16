open Session_Type
open AWS.Lambda

let getSessionConfiguration: Event.t<sessionConfigurationPathParam> => result<
  practiceSessionRequest,
  response,
>

let createSession: practiceSessionRequest => practiceSession
