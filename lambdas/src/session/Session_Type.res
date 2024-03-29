open Project.Type

type sessionConfigurationPathParam = {projectName: string, exerciseCount: int}

type practiceSessionDBRequest = {projectTableKey: Database.key, exerciseCount: int}

type practiceSessionCreatorRequest = {project: Database.Get.t, exerciseCount: int}

@spice
type practiceSession = {
  projectName: string,
  exercises: list<Exercise.Type.toPractice>,
  topPriorityExercises: list<Exercise.Type.toPractice>,
}
