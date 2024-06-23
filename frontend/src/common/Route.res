module FrontEnd = {
  type t = [#"/" | #"/signIn" | #"/signIn/redirect"]

  let home: t = #"/"
  let signIn: t = #"/signIn"
  let signInRedirect: t = #"/signIn/redirect"

  let push = (router, ~route: t) => router->Next.Navigation.Router.push((route :> string))
}

module BackEnd = {
  type t = [#"/project"]

  let project: t = #"/project"
}
