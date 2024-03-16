type sessionConfigurationPathParam = {projectName: string, exerciseCount: int}

type practiceSessionRequest = {projectTableKey: Project.Type.Database.key, exerciseCount: int}

type practiceSession = {
  projectTableKey: Project.Type.Database.key,
  exercises: list<Exercise.Type.t>,
  topPriorityExercises: list<Exercise.Type.t>,
}
