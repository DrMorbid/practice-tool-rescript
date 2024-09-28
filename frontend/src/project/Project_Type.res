@spice
type t = {
  name: string,
  active: bool,
  exercises: array<Exercise.Type.t>,
}

@spice
type projects = array<t>

@spice
type projectForRequest = {
  name: string,
  originalName?: string,
  active: bool,
  exercises: array<Exercise.Type.t>,
}

@spice
type practiced = {
  name: string,
  exercises: array<Exercise.Type.practiced>,
}
