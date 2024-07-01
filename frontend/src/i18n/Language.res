type t = En | Cs

let toString = language =>
  switch language {
  | En => "en"
  | Cs => "cs"
  }
