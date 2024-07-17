open Exercise_Type

let unitOfTempo = "%"

let formatTempo = tempo => `${tempo->Int.toString}\u00A0${unitOfTempo}`

let getStateIcon = ({active, topPriority}) =>
  switch (active, topPriority) {
  | (false, _) => <Icon.NotInterested />
  | (true, false) => Jsx.null
  | (true, true) => <Icon.PriorityHigh />
  }

let getOrdering = (
  {active: active1, topPriority: topPriority1, name: name1},
  {active: active2, topPriority: topPriority2, name: name2},
): Ordering.t => {
  switch (active1, topPriority1, active2, topPriority2) {
  | (false, _, true, _) | (true, false, true, true) => Ordering.greater
  | (true, _, false, _) | (true, true, true, false) => Ordering.less
  | (false, _, false, _) | (true, false, true, false) | (true, true, true, true) =>
    name1->String.compare(name2)
  }
}
