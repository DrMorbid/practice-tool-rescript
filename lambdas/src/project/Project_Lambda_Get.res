open Utils.Lambda
open Project_Type
open Project_Utils

module GetProjectResponse = {
  type t = Database.t
  let encode = Database.t_encode
}
module Response = MakeBodyResponder(GetProjectResponse)

let handler: AWS.Lambda.handler<projectNamePathParam> = async event =>
  switch event
  ->getProjectTableKey
  ->Result.map(async projectTableKey => {
    let dbResponse = await projectTableKey->DBGetter.get
    Response.createResponse(~dbResponse?)
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
