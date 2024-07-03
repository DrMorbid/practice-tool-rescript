@spice
type error = {message: string}

type t<'a> = NotStarted | Pending | Ok('a) | Error(error)

let isError = response =>
  switch response {
  | NotStarted | Pending | Ok(_) => false
  | Error(_) => true
  }
