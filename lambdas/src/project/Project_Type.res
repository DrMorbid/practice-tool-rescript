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
    name?: string,
    active?: bool,
    exercises?: array<Exercise.Type.FromRequest.t>,
  }
}

@spice
type dbKey = {
  userId: string,
  name: string,
}

type projectNamePathParam = {name: string}
