module FrontEnd = {
  type t = [#"/" | #"/signIn" | #"/signIn/redirect" | #"/manage" | #"/manage/projectAdd"]

  let push = (router, ~route: t) => router->Next.Navigation.Router.push((route :> string))
}

module BackEnd = {
  type t = [#"/project"]

  let project: t = #"/project"
}
