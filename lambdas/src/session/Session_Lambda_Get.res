open AWS.Lambda
open Session_Type
open Project.Utils
open Session_Utils
open Utils.Lambda

module GetProjectResponse = {
  @spice
  type t = practiceSession
  let encode = t_encode
}
module Response = MakeBodyResponder(GetProjectResponse)

let handler: handler<sessionConfigurationPathParam> = async event =>
  switch event
  ->Session_Utils.getSessionConfiguration
  ->Result.map(async ({projectTableKey, exerciseCount}) => {
    let dbResponse: option<Project.Type.t> = await projectTableKey->DBGetter.get
    Console.log3(
      "Got project %o, will prepare practice session with %i exercises",
      dbResponse,
      exerciseCount,
    )

    dbResponse
    ->Option.map(project => {project, exerciseCount}->createSession)
    ->Response.create
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
