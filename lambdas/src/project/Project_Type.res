@spice
type t = {
  userId: string,
  name: string,
  active: bool,
  exercises: array<Exercise.Type.t>,
}

module FromRequest = {
  @spice
  type t = {
    userId?: string,
    name?: string,
    active?: bool,
    exercises?: array<Exercise.Type.FromRequest.t>,
  }
}

type dbKey = {
  userId: string,
  projectName: string,
}

type projectNamePathParam = {name: string}
