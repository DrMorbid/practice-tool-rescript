open Exercise_Type

let toDbSaveItem = exercise =>
  exercise.name
  ->Utils.String.toNotBlank
  ->Option.map((name): Database.Save.t => {
    name,
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
