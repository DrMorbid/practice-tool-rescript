let fromRequest = (exercise: Exercise_Type.FromRequest.t): option<Exercise_Type.t> =>
  exercise.name
  ->Utils.String.toNotBlank
  ->Option.map((name): Exercise_Type.t => {
    name,
    active: exercise.active->Option.getOr(false),
    topPriority: exercise.topPriority->Option.getOr(false),
    slowTempo: exercise.slowTempo->Option.getOr(Exercise_Constant.defaultSlowTempo),
    fastTempo: exercise.fastTempo->Option.getOr(Exercise_Constant.defaultFastTempo),
    lastPracticed: ?exercise.lastPracticed->Option.flatMap(({?date, ?tempo}): option<
      Exercise_Type.lastPracticed,
    > =>
      switch (date, tempo) {
      | (Some(date), Some(tempo)) => Some({date, tempo})
      | _ => None
      }
    ),
  })

let isSlow = (tempo: Exercise_Type.tempo) =>
  switch tempo {
  | Slow => true
  | Fast => false
  }

let switchTempo = ({name, slowTempo, fastTempo, ?lastPracticed}: Exercise_Type.t) =>
  lastPracticed->Option.map(({tempo: lastPracticedTempo}): Exercise_Type.toPractice => {
    name,
    tempo: lastPracticedTempo->isSlow ? Fast : Slow,
    tempoValue: lastPracticedTempo->isSlow ? fastTempo : slowTempo,
  })

let sortByLastPracticedDateDate = (exercises: array<Exercise_Type.t>) =>
  exercises->Array.toSorted((exercise1, exercise2) =>
    exercise1.lastPracticed->Option.compare(exercise2.lastPracticed, (
      lastPracticed1,
      lastPracticed2,
    ) => lastPracticed1.date->Date.compare(lastPracticed2.date))
  )

let convert = ({name, slowTempo, fastTempo}: Exercise_Type.t, ~tempo): Exercise_Type.toPractice => {
  name,
  tempo,
  tempoValue: tempo == Slow ? slowTempo : fastTempo,
}
let convertOption = (exercise, ~tempo) => exercise->Option.map(convert(_, ~tempo))
