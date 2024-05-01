open Exercise.Type

type sessionConfigurationPathParam = {projectName: string, exerciseCount: int}

type practiceSessionDBRequest = {projectTableKey: Project.Type.dbKey, exerciseCount: int}

type practiceSessionCreatorRequest = {project: Project.Type.t, exerciseCount: int}

@spice
type practiceSession = {
  name: string,
  exercises: list<toPractice>,
  topPriorityExercises: list<toPractice>,
}

@spice
type historyItem = {
  userId: string,
  date: @spice.codec(Utils.Date.SpiceCodec.date) Date.t,
  exercises: array<exerciseSession>,
}

type exerciseToUpdate = {
  name: string,
  lastPracticed: lastPracticed,
}

type projectToUpdate = {
  name: string,
  exercises: array<exerciseToUpdate>,
}

type projectsToUpdate = {
  userId: string,
  projects: array<projectToUpdate>,
}

type saveSessionWrapper = {
  projects: projectsToUpdate,
  historyItem: historyItem,
}

module FromRequest = {
  @spice
  type projectSession = {name?: string, exercises: array<FromRequest.exerciseSession>}
  @spice
  type practiceSession = array<projectSession>
}
