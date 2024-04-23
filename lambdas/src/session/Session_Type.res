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
type storedPracticeSession = {
  userId: string,
  date: @spice.codec(Utils.Date.SpiceCodec.date) Date.t,
  exercises: array<exerciseSession>,
}

module FromRequest = {
  @spice
  type projectSession = {name: string, exercises: array<FromRequest.exerciseSession>}
  @spice
  type practiceSession = array<projectSession>
}
