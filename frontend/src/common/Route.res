module FrontEnd = {
  type t = [
    | #"/"
    | #"/signIn"
    | #"/signIn/redirect"
    | #"/practice"
    | #"/manage"
    | #"/manage/projectDetail"
  ]

  let push = (router, ~route: t) => router->Next.Navigation.Router.push((route :> string))
}

module BackEnd = {
  type t = Project | ProjectWithName(string)

  let toString = project =>
    switch project {
    | Project => "/project"
    | ProjectWithName(name) => `/project/${name}`
    }
}
