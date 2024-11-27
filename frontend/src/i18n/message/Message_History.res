open ReactIntl

@@intl.messages

let historyTitle =
  @intl.description("History page - header")
  {
    id: "7144368f-c18e-4db6-86e1-3652fb27b119",
    defaultMessage: "Practice History",
  }

let selectStartDate =
  @intl.description("History page - label of the field for start date selection")
  {
    id: "1381b724-cd2f-4fa8-8c34-ba9119e62651",
    defaultMessage: "Start date",
  }

let couldNotLoadHistory =
  @intl.description("History page - header of the error alert when the history failed to be loaded")
  {
    id: "941c95bb-df2b-4592-9e8e-492f00330f17",
    defaultMessage: "Could not load history statistics",
  }

let noHistoryForThePeroid =
  @intl.description(
    "History page - header of the info alert explaining that there is no history to be displayed for the selected time period"
  )
  {
    id: "ed226dc1-c255-4830-835e-8fdc52e09635",
    defaultMessage: "Nothing has been practiced since {dateFrom}",
  }

let practiced =
  @intl.description(
    "History page - label of the field showing how many times it was practiced for that period"
  )
  {
    id: "f35114d7-49c9-46fc-9734-710dae6c3979",
    defaultMessage: "Practiced {times} times",
  }

let unpracticedExercises =
  @intl.description("History page - label of the list of exercises not practiced for that period")
  {
    id: "830e4a1b-c9ec-4490-a87d-2e85383f2e3b",
    defaultMessage: "Unpracticed exercises",
  }

let noUnpracticedExercises =
  @intl.description(
    "History page - text instead of the list of unpracticed exercises in the case when all have been practiced"
  )
  {
    id: "06ff11eb-f18c-4a9f-ba13-463d6fc30a9a",
    defaultMessage: "None",
  }
