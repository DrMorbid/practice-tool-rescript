let getStateIcon = (~active) =>
  switch active {
  | false => <Icon.NotInterested />
  | true => Jsx.null
  }
