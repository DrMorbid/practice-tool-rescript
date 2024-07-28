@spice
type error = {message: string}

type t<'a> = NotStarted | Pending | Ok('a) | Error(error)

let isError = response =>
  switch response {
  | NotStarted | Pending | Ok(_) => false
  | Error(_) => true
  }

let forSuccess = (response, onSuccess) =>
  switch response {
  | Ok(response) => response->onSuccess
  | NotStarted | Pending | Error(_) => ()
  }
