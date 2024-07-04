type state = int
type action =
  | Increment
  | Decrement

let api = Restorative.createStore(0, (state, action) =>
  switch action {
  | Increment => state + 1
  | Decrement => state - 1
  }
)
