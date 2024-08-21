open Project_Type

let getStateIcon = (~active) =>
  switch active {
  | false => <Icon.NotInterested />
  | true => Jsx.null
  }

let getOrdering = ({active: active1, name: name1}, {active: active2, name: name2}): Ordering.t => {
  switch (active1, active2) {
  | (false, true) => Ordering.greater
  | (true, false) => Ordering.less
  | (false, false) | (true, true) => name1->String.compare(name2)
  }
}
