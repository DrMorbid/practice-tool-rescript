module FrontEnd = {
  type t = [#"/" | #"/signIn" | #"/signIn/redirect" | #"/manage"]

  let home: t = #"/"
  let signIn: t = #"/signIn"
  let signInRedirect: t = #"/signIn/redirect"
  let manage: t = #"/manage"

  let push = (router, ~route: t) => router->Next.Navigation.Router.push((route :> string))
}

module BackEnd = {
  type t = [#"/project"]

  let project: t = #"/project"
}
