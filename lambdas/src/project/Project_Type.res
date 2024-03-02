@spice
type t = {
  userId?: string,
  name?: string,
  active?: bool,
  exercises?: array<Exercise.Type.t>,
}

module Database = {
  type t = {
    @as("user-id") userId: string,
    name: string,
    active: bool,
    exercises: array<Exercise.Type.Database.t>,
  }

  type key = {
    @as("user-id") userId: string,
    name: string,
  }
}
