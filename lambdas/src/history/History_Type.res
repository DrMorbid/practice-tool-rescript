@spice
type t = {
  userId: string,
  date: @spice.codec(Util.Date.SpiceCodec.date) Date.t,
  exercises: array<Exercise.Type.exerciseSession>,
}

@spice
type historyRequest = {dateFrom: @spice.codec(Util.Date.SpiceCodec.date) Date.t}

@spice
type historyStatisticsByTempo = {
  tempo: Exercise.Type.tempo,
  practiceCount: int,
}

@spice
type historyStatisticsByExercise = {
  exerciseName: string,
  practiceCount: int,
  byTempos: array<historyStatisticsByTempo>,
}

@spice
type historyStatisticsByProject = {
  projectName: string,
  practiceCount: int,
  byExercises: array<historyStatisticsByExercise>,
  notPracticedExercises: array<string>,
}

@spice
type historyStatistics = array<historyStatisticsByProject>
