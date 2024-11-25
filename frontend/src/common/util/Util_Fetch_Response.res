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

let mapSuccess = (response, onSuccess) =>
  switch response {
  | Ok(response) => Ok(response->onSuccess)
  | NotStarted => NotStarted
  | Pending => Pending
  | Error(error) => Error(error)
  }

let toOption = response =>
  switch response {
  | Ok(response) => Some(response)
  | NotStarted | Pending | Error(_) => None
  }

let errorToOption = response =>
  switch response {
  | Error(error) => Some(error)
  | NotStarted | Pending | Ok(_) => None
  }
