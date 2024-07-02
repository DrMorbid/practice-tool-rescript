@spice
type t = {
  userId: string,
  name: string,
  active: bool,
  exercises: array<Exercise.Type.t>,
}

@spice
type projects = array<t>
