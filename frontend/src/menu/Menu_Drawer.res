@react.component
let make = (~menuRef) => {
  let intl = ReactIntl.useIntl()
  let router = Next.Navigation.useRouter()
  let activeItem = Store.useStoreWithSelector(({?menuItemIndex}) => menuItemIndex)

  let onClick = (route, index, _) => {
    Store.dispatch(StoreMenuItemIndex(index))

    router->Route.FrontEnd.push(~route)
  }

  <Mui.Drawer variant={Permanent} anchor={Left}>
    <Mui.List ref={menuRef->ReactDOM.Ref.domRef}>
      {Menu_Content.menuContent
      ->Array.mapWithIndex(({label, icon, route}, index) =>
        <Mui.ListItem key={`menu-item-${index->Int.toString}`}>
          <Mui.ListItemButton
            selected={index == activeItem->Option.getOr(0) ? true : false}
            onClick={onClick(route, index, _)}>
            <Mui.ListItemIcon> icon </Mui.ListItemIcon>
            <Mui.ListItemText primary={intl->ReactIntl.Intl.formatMessage(label)->Jsx.string} />
          </Mui.ListItemButton>
        </Mui.ListItem>
      )
      ->Jsx.array}
    </Mui.List>
  </Mui.Drawer>
}
