open ReactIntl

@@intl.messages

let selectProjectTitle =
  @intl.description("Practice session configuration page - header")
  {
    id: "f0ca41a4-5b89-4cdf-9534-fdb447062bca",
    defaultMessage: "Select a project",
  }

let projectName =
  @intl.description("Practice session - field: project name selection")
  {
    id: "9961ec3c-1c9b-4ae9-a8cc-dd3607979af5",
    defaultMessage: "Project name",
  }

let exerciseCount =
  @intl.description("Practice session - field: exercise count selection")
  {
    id: "fb594005-a3f0-4b4a-bd34-8d9084d9da5a",
    defaultMessage: "Exercises",
  }

let topPriorityCountInfoCard =
  @intl.description(
    "Practice session - info card - how many top priority exercises this project contains"
  )
  {
    id: "a5833281-e9cd-4231-926d-ae41b9116487",
    defaultMessage: "This project contains {count, plural, one {# top priority exercise} two {# top priority exercises} few {# top priority exercises} many {# top priority exercises} other {# top priority exercises}}.",
  }

let couldNotLoadSession =
  @intl.description("Practice overview page - error title - could not load exercises to practice")
  {
    id: "a4f0786b-4531-4456-860c-a692aeca71f9",
    defaultMessage: "Could not load exercises to practice",
  }

let startPracticingTitle =
  @intl.description("Practice session overview page - header")
  {
    id: "e71f2311-383c-4c2a-8edf-7ec725e65323",
    defaultMessage: "Start practicing",
  }

let sessionSavedSuccessfully =
  @intl.description("Session - success title - session saved successfully")
  {
    id: "5d5e8bc8-65aa-4c4d-870d-e1dec40c84c8",
    defaultMessage: "Session saved",
  }
