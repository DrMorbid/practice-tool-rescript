open ReactIntl

@@intl.messages

let projects =
  @intl.description("Project - title of the projects manage page")
  {
    id: "2903cc2e-f7b1-4313-9447-065b778bc114",
    defaultMessage: "Projects",
  }

let name =
  @intl.description("Project - field: name")
  {
    id: "68bd7e01-8aa2-42e0-b757-2729fb3f301c",
    defaultMessage: "Name",
  }

let active =
  @intl.description("Project - field: active")
  {
    id: "2da32407-1777-49e1-b921-69581f50d59d",
    defaultMessage: "Active",
  }

let exercises =
  @intl.description("Project - field: exercises")
  {
    id: "9599952f-8f1b-416d-b069-b5035cd20ed9",
    defaultMessage: "Exercises",
  }

let couldNotLoadProject =
  @intl.description("Project - error title - could not load projects")
  {
    id: "275226d4-b668-4736-a5e8-091d53b19ca7",
    defaultMessage: "Could not load projects",
  }

let couldNotSaveProject =
  @intl.description("Project - error title - could not save a project")
  {
    id: "b380aa54-e021-46fc-ad27-d30186a6e326",
    defaultMessage: "Could not save the project",
  }

let couldNotDeleteProject =
  @intl.description("Project - error title - could not delete a project")
  {
    id: "b7b9555f-15be-40c3-8ef1-027cb59d00f4",
    defaultMessage: "Could not delete the project",
  }

let projectSavedSuccessfully =
  @intl.description("Project - success title - project saved successfully")
  {
    id: "13a33a8f-200b-4677-807f-8495594c8733",
    defaultMessage: "Project {projectName} saved",
  }

let projectDeletedSuccessfully =
  @intl.description("Project - success title - project deleted successfully")
  {
    id: "bcebc4a4-0cbd-4e35-91d8-d2e46d9bf09a",
    defaultMessage: "Project {projectName} deleted",
  }
