open Restorative

module Action = Store_Action
module State = Store_State

let {useStoreWithSelector, dispatch} = createStore(State.initialState, (
  state,
  action: Action.action,
) =>
  switch action {
  | StoreMenuItemIndex(menuItemIndex) => {...state, menuItemIndex}
  | StoreBottomBarHeight(bottomBarHeight) => {
      ...state,
      bottomBarHeight,
    }
  | ResetBottomBarHeight => {...state, bottomBarHeight: ?State.initialState.bottomBarHeight}
  | StoreDrawerWidth(drawerWidth) => {...state, drawerWidth}
  | ResetDrawerWidth => {...state, drawerWidth: ?State.initialState.drawerWidth}
  | StoreSelectedProjectForManagement(selectedProjectForManagement) => {
      ...state,
      selectedProjectForManagement,
    }
  }
)
