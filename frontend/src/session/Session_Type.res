@spice
type t = {projectName: string, exercisesCount: int}

@spice
type toPractice = {
  name: string,
  exercises: list<Exercise_Type.toPractice>,
  topPriorityExercises: list<Exercise_Type.toPractice>,
}

@spice
type practiced = array<Project_Type.practiced>
