open AWS.Lambda
open Utils.Lambda
open Session_Type

let getSessionConfiguration = event =>
  event
  ->getUser
  ->Result.flatMap((userId): result<practiceSessionRequest, response> =>
    event.pathParameters
    ->Option.flatMap(({projectName, exerciseCount}) =>
      Some({name: projectName})
      ->Project.Utils.toProjectTableKey(~userId)
      ->Option.map(projectTableKey => {projectTableKey, exerciseCount})
    )
    ->Option.map(practiceSessionRequest => Ok(practiceSessionRequest))
    ->Option.getOr(
      Error({statusCode: 400, body: "Project name must be present in path parameters"}),
    )
  )

let createSession = ({projectTableKey}) => {
  projectTableKey,
  exercises: list{},
  topPriorityExercises: list{},
}
