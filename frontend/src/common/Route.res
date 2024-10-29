module FrontEnd = {
  type t =
    | Home
    | SignIn
    | SignInRedirect
    | Practice
    | PracticeOverview(string, int)
    | PracticeOverviewNew(array<Session_Type.t>)
    | Manage
    | ManageProjectDetail

  let toString = route =>
    switch route {
    | Home => "/"
    | SignIn => "/signIn"
    | SignInRedirect => "/signIn/redirect"
    | Practice => "/practice"
    | PracticeOverview(projectName, exerciseCount) =>
      `/practice/overview?projectName=${projectName}&exerciseCount=${exerciseCount->Int.toString}`
    | PracticeOverviewNew(sessions) =>
      `/practice/overview?sessions=${Spice.arrayToJson(
          Session_Type.t_encode,
          sessions,
        )->JSON.stringify}`
    | Manage => "/manage"
    | ManageProjectDetail => "/manage/projectDetail"
    }

  let push = (router, ~route: t) => router->Next.Navigation.Router.push(route->toString)
}

module BackEnd = {
  type t = Project | ProjectWithName(string) | Session | SessionWithNameAndCount(string, int)

  let toString = route =>
    switch route {
    | Project => "/project"
    | ProjectWithName(name) => `/project/${name}`
    | Session => "/session"
    | SessionWithNameAndCount(projectName, exerciseCount) =>
      `/session/${projectName}/${exerciseCount->Int.toString}`
    }
}
