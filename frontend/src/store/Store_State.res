type state = {
  menuItemIndex?: int,
  bottomBarHeight?: int,
  drawerWidth?: int,
  selectedProjectForManagement?: Project_Type.t,
  processFinishedSuccessfullyMessage?: Text.t,
}

let initialState: state = {}
