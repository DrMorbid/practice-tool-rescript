type t = {
  label: ReactIntl.message,
  icon: Jsx.element,
  route: Route.FrontEnd.t,
}

let menuContent = [
  {label: Message.Menu.home, icon: <Icon.HomeTwoTone />, route: #"/"},
  {label: Message.Menu.manage, icon: <Icon.BuildTwoTone />, route: #"/manage"},
]
