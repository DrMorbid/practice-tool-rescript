open Session_Type
open AWS.Lambda

let getSessionConfiguration: Event.t<sessionConfigurationPathParam> => result<
  practiceSessionDBRequest,
  response,
>

let createSession: practiceSessionCreatorRequest => practiceSession
