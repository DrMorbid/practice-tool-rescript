type state = {
  locale: Intl.Locale.t,
  menuItemIndex?: int,
  bottomBarHeight?: int,
  drawerWidth?: int,
  selectedProjectForManagement?: Project_Type.t,
  processFinishedSuccessfullyMessage?: Text.t,
}

let initialState: state = {
  locale: Intl.Locale.make("en"),
}
