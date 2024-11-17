open AWS.Lambda
open Session_Type
open Project.Util
open Session_Util
open Util.Lambda

module GetProjectResponse = {
  @spice
  type t = practiceSession
  let encode = t_encode
}
module Response = MakeBodyResponder(GetProjectResponse)

let handler: handler<sessionConfigurationPathParam, 'b> = async event =>
  switch event
  ->Session_Util.getSessionConfiguration
  ->Result.map(async ({projectTableKey, exerciseCount}) => {
    let project = await projectTableKey->DBGetter.get

    let project = project->Result.flatMap(validateSessionConfiguration(_, ~exerciseCount))

    project->Result.forEach(project =>
      Console.log3(
        "Got project %o, will prepare practice session with %i exercises",
        project,
        exerciseCount,
      )
    )

    project
    ->Result.map(project => {project, exerciseCount}->createSession)
    ->Response.create
  })
  ->Result.map(async result => {
    let result = await result
    switch result {
    | Ok(result) => result
    | Error(result) => result
    }
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
