@spice
type t = {
  userId?: string,
  name?: string,
  active?: bool,
  exercises?: array<Exercise.Type.t>,
}

module Database = {
  module Save = {
    type t = {
      @as("user-id") userId: string,
      name: string,
      active: bool,
      exercises: array<Exercise.Type.Database.Save.t>,
    }
  }

  module Get = {
    type t = {
      @as("user-id") userId: string,
      name: string,
    }
  }
}
