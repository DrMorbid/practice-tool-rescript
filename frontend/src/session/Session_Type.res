type t = {projectName: string, exerciseCount: int}

@spice
type toPractice = {
  name: string,
  exercises: list<Exercise.Type.toPractice>,
  topPriorityExercises: list<Exercise.Type.toPractice>,
}

@spice
type sessionSaveRequestExercise = {
  name: string,
  tempo: Exercise.Type.tempo,
}

@spice
type sessionSaveRequestItem = {
  name: string,
  exercises: array<sessionSaveRequestExercise>,
}

@spice
type sessionSaveRequest = array<sessionSaveRequestItem>
