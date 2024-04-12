open Session_Type
open AWS.Lambda

let getSessionConfiguration: Event.t<sessionConfigurationPathParam> => result<
  practiceSessionDBRequest,
  response,
>

let validateSessionConfiguration: (
  ~exerciseCount: int,
  Project.Type.t,
) => result<Project.Type.t, response>

let createSession: practiceSessionCreatorRequest => practiceSession
