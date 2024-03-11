open AWS.Lambda
open Session_Type
open Project_Utils

let handler: handler<sessionConfigurationPathParam> = async event =>
  switch event
  ->Session_Utils.getSessionConfiguration
  ->Result.map(async ({projectTableKey, exerciseCount}) => {
    let dbResponse = await projectTableKey->DBGetter.get
    Console.log3(
      "Got project %o, will prepare practice session with %i exercises",
      dbResponse,
      exerciseCount,
    )
    {statusCode: 200, body: "Go practice!"}
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
