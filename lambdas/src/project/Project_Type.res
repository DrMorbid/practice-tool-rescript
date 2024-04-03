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

@spice
type dbKey = {
  userId: string,
  @as("name") projectName: string,
}

type projectNamePathParam = {name: string}
