open Session_Type
open AWS.Lambda

let getSessionConfiguration: Event.t<array<sessionConfigurationPathParam>> => result<
  array<practiceSessionDBRequest>,
  response,
>

let validateSessionConfiguration: (
  ~exerciseCount: int,
  Project.Type.t,
) => result<Project.Type.t, response>

let createSession: practiceSessionCreatorRequest => practiceSession

let fromRequest: (~userId: string, FromRequest.practiceSession) => result<historyItem, response>

let toSaveSessionWrapper: (
  ~userId: string,
  result<historyItem, 'a>,
) => result<saveSessionWrapper, 'a>

let updateProjects: (
  ~userId: string,
  ~saveToDb: Project.Type.t => promise<response>,
  array<projectToUpdate>,
) => promise<array<response>>
