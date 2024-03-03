@spice
type t = {
  userId?: string,
  projectName?: string,
  active?: bool,
  exercises?: array<Exercise.Type.t>,
}

module Database = {
  @spice
  type t = {
    userId: string,
    projectName: string,
    active: bool,
    exercises: array<Exercise.Type.Database.t>,
  }

  type key = {
    userId: string,
    projectName: string,
  }
}
