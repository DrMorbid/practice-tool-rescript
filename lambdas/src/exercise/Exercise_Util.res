let fromRequest = (
  {
    ?name,
    ?active,
    ?topPriority,
    ?slowTempo,
    ?fastTempo,
    ?lastPracticed,
  }: Exercise_Type.FromRequest.t,
): option<Exercise_Type.t> =>
  name
  ->Util.String.toNotBlank
  ->Option.map((name): Exercise_Type.t => {
    name,
    active: active->Option.getOr(false),
    topPriority: topPriority->Option.getOr(false),
    slowTempo: slowTempo->Option.getOr(Exercise_Constant.defaultSlowTempo),
    fastTempo: fastTempo->Option.getOr(Exercise_Constant.defaultFastTempo),
    lastPracticed: ?lastPracticed->Option.flatMap(({?date, ?tempo}): option<
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

let fromSessionRequest = (
  ~projectName=?,
  {?name, ?tempo}: Exercise_Type.FromRequest.exerciseSession,
) =>
  projectName
  ->Option.map(projectName =>
    name
    ->Util.String.toNotBlank
    ->Option.flatMap(name =>
      tempo->Option.map(tempo => Ok({Exercise_Type.name, projectName, tempo}))
    )
    ->Option.getOr(
      Error({
        AWS.Lambda.statusCode: 400,
        headers: Util.Lambda.defaultResponseHeaders,
        body: "Missing exercise name or tempo",
      }),
    )
  )
  ->Option.getOr(
    Error({
      AWS.Lambda.statusCode: 400,
      headers: Util.Lambda.defaultResponseHeaders,
      body: "Missing project name",
    }),
  )
