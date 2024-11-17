open History_Type
open AWS.Lambda
open Util.Lambda

module DBQuery = {
  type t = t
  let decode = t_decode
  let tableName = Global.EnvVar.tableNameHistory
}
module DBQueryCaller = Util.DynamoDB.DBQueryCaller(DBQuery)

module GetHistoryResponse = {
  @spice
  type t = array<t>
  let encode = t_encode
}
module Response = MakeBodyResponder(GetHistoryResponse)

let handler: handler<'a, historyRequest> = async event =>
  switch event
  ->getUserAndQueryParams(~decode=historyRequest_decode)
  ->Result.map(async ((userId, historyRequest)) => {
    let dbResponse = await DBQueryCaller.query(
      ~userId,
      ~additionalConditions=?historyRequest->Option.map(({dateFrom}): array<
        Util.DynamoDB.additionalExpression,
      > => [{fieldName: "date", operator: ">=", value: dateFrom->Date.toISOString}]),
    )
    Ok(dbResponse)->Response.create
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
