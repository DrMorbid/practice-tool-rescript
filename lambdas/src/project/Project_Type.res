@spice
type t = {
  userId?: string,
  projectName?: string,
  active?: bool,
  exercises?: array<Exercise.Type.t>,
}

module Database = {
  module Save = {
    @spice
    type t = {
      userId: string,
      projectName: string,
      active: bool,
      exercises: array<Exercise.Type.Database.Save.t>,
    }
  }

  module Get = {
    @spice
    type t = {
      userId: string,
      projectName: string,
      active: bool,
      exercises: array<Exercise.Type.Database.Get.t>,
    }
  }

  type key = {
    userId: string,
    projectName: string,
  }
}

type projectNamePathParam = {name: string}
