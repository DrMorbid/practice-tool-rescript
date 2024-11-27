type action =
  | StoreLocale(Intl.Locale.t)
  | StoreMenuItemIndex(int)
  | StoreBottomBarHeight(int)
  | ResetBottomBarHeight
  | StoreDrawerWidth(int)
  | ResetDrawerWidth
  | StoreSelectedProjectForManagement(Project_Type.t)
  | ResetProjectForManagement
  | StoreProcessFinishedSuccessfullyMessage(Text.t)
  | ResetProcessFinishedSuccessfullyMessage
