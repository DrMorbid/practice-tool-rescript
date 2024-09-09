open Util.Lambda
open Project_Util

module GetProjectResponse = {
  @spice
  type t = Project_Type.t
  let encode = t_encode
}
module Response = MakeBodyResponder(GetProjectResponse)

let handler: AWS.Lambda.handler<Project_Type.projectNamePathParam> = async event => {
  switch event
  ->getProjectTableKey
  ->Result.map(async projectTableKey => {
    let dbResponse = await projectTableKey->DBGetter.get
    dbResponse->Response.create
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
}
