type t = {
  label: ReactIntl.message,
  icon: Jsx.element,
  route: Route.FrontEnd.t,
}

let menuContent = [
  {label: Message.Menu.home, icon: <Icon.Home />, route: #"/"},
  {label: Message.Menu.practice, icon: <Icon.MusicNote />, route: #"/practice"},
  {label: Message.Menu.manage, icon: <Icon.Build />, route: #"/manage"},
]
