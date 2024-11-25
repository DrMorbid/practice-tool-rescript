type t = {
  label: ReactIntl.message,
  icon: Jsx.element,
  route: Route.FrontEnd.t,
}

let menuContent = [
  {label: Message.Menu.practice, icon: <Icon.MusicNote />, route: Practice},
  {label: Message.Menu.manage, icon: <Icon.Build />, route: Manage},
  {label: Message.Menu.history, icon: <Icon.History />, route: History},
]
