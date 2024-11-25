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
