type action =
  | StoreMenuItemIndex(int)
  | StoreBottomBarHeight(int)
  | ResetBottomBarHeight
  | StoreDrawerWidth(int)
  | ResetDrawerWidth
  | StoreSelectedProjectForManagement(Project_Type.t)
  | ResetProjectForManagement
