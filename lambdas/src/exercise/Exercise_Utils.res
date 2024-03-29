open Exercise_Type

let toDBSaveItem = exercise =>
  exercise.exerciseName
  ->Utils.String.toNotBlank
  ->Option.map((exerciseName): Database.Save.t => {
    exerciseName,
    active: exercise.active->Option.getOr(false),
    topPriority: exercise.topPriority->Option.getOr(false),
    slowTempo: exercise.slowTempo->Option.getOr(Exercise_Constant.defaultSlowTempo),
    fastTempo: exercise.fastTempo->Option.getOr(Exercise_Constant.defaultFastTempo),
    lastPracticed: ?exercise.lastPracticed->Option.flatMap(({?date, ?tempo}): option<
      Database.Save.lastPracticed,
    > =>
      switch (date, tempo->Option.map(tempo_encode)->Option.flatMap(JSON.Decode.string)) {
      | (Some(date), Some(tempo)) => Some({date: date->Date.toISOString, tempo})
      | _ => None
      }
    ),
  })

let isSlow = tempo =>
  switch tempo {
  | Slow => true
  | Fast => false
  }

let switchTempo = ({exerciseName, slowTempo, fastTempo, ?lastPracticed}: Database.Get.t) =>
  lastPracticed->Option.map(({tempo: lastPracticedTempo}) => {
    exerciseName,
    tempo: lastPracticedTempo->isSlow ? Fast : Slow,
    tempoValue: lastPracticedTempo->isSlow ? fastTempo : slowTempo,
  })
