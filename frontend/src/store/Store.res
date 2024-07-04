open Restorative

module Action = Store_Action
module State = Store_State

let {useStoreWithSelector, dispatch} = createStore(State.initialState, (
  _state,
  action: Action.action,
) =>
  switch action {
  | StoreMenuItemIndex(menuItemIndex) => {menuItemIndex: menuItemIndex}
  }
)
