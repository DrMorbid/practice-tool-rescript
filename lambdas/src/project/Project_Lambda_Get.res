open Utils.Lambda
open Project_Type
open Project_Utils

module GetProjectResponse = {
  @spice
  type t = Database.Get.t
  let encode = t_encode
}
module Response = MakeBodyResponder(GetProjectResponse)

let handler: AWS.Lambda.handler<projectNamePathParam> = async event =>
  switch event
  ->getProjectTableKey
  ->Result.map(async projectTableKey => {
    let dbResponse = await projectTableKey->DBGetter.get
    dbResponse->Response.create
  }) {
  | Ok(result) => await result
  | Error(result) => result
  }
