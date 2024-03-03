open Exercise_Type

let toDBSaveItem = exercise =>
  exercise.exerciseName
  ->Utils.String.toNotBlank
  ->Option.map((exerciseName): Database.t => {
    exerciseName,
    active: exercise.active->Option.getOr(false),
    topPriority: exercise.topPriority->Option.getOr(false),
    slowTempo: exercise.slowTempo->Option.getOr(Exercise_Constant.defaultSlowTempo),
    fastTempo: exercise.fastTempo->Option.getOr(Exercise_Constant.defaultFastTempo),
    lastPracticed: ?exercise.lastPracticed->Option.flatMap(({?date, ?tempo}): option<
      Database.lastPracticed,
    > =>
      switch (date, tempo->Option.map(tempo_encode)->Option.flatMap(JSON.Decode.string)) {
      | (Some(date), Some(tempo)) => Some({date: date->Date.toISOString, tempo})
      | _ => None
      }
    ),
  })
