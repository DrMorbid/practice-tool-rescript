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

let practiced =
  @intl.description(
    "History page - label of the field showing how many times it was practiced for that period"
  )
  {
    id: "f35114d7-49c9-46fc-9734-710dae6c3979",
    defaultMessage: "Practiced {times} times",
  }
