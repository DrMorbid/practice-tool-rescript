type sessionConfigurationPathParam = {projectName: string, exerciseCount: int}

type practiceSessionDBRequest = {projectTableKey: Project.Type.dbKey, exerciseCount: int}

type practiceSessionCreatorRequest = {project: Project.Type.t, exerciseCount: int}

@spice
type practiceSession = {
  name: string,
  exercises: list<Exercise.Type.toPractice>,
  topPriorityExercises: list<Exercise.Type.toPractice>,
}
