type t = {projectName: string, exercisesCount: int}

@spice
type toPractice = {
  name: string,
  exercises: list<Exercise.Type.toPractice>,
  topPriorityExercises: list<Exercise.Type.toPractice>,
}

@spice
type practiced = array<Project.Type.practiced>
