open Restorative

type state = {
  a: int,
  b: int,
}
type action =
  | IncrementA
  | IncrementB

let {subscribeWithSelector, dispatch, useStoreWithSelector} = createStore({a: 0, b: 0}, (
  state,
  action,
) =>
  switch action {
  | IncrementA => {...state, a: state.a + 1}
  | IncrementB => {...state, b: state.b + 1}
  }
)

let sub = subscribeWithSelector(state => state.a, a => Js.log(a))
dispatch(IncrementA) // calls listener
dispatch(IncrementB) // does not call listener
