open AWS.Lambda
open Project_Type

let toDBSaveItem = (~userId, {?name, ?active, exercises: ?inputExercises}): result<
  Database.Save.t,
  response,
> => {
  let exercises =
    inputExercises->Option.getOr([])->Array.map(Exercise.Utils.toDBSaveItem)->Array.keepSome

  if exercises->Array.length < inputExercises->Option.getOr([])->Array.length {
    Error({statusCode: 400, body: "Exercise name cannot be empty"})
  } else {
    name
    ->Utils.String.toNotBlank
    ->Option.map((name): result<Database.Save.t, 'a> => Ok({
      userId,
      name,
      active: active->Option.getOr(false),
      exercises,
    }))
    ->Option.getOr(Error({statusCode: 400, body: "Project name cannot be empty"}))
  }
}

let toDBGetItem = (~userId, name): result<Database.Get.t, response> => Ok({userId, name})
