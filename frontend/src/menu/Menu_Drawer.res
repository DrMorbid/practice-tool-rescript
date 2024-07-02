@react.component
let make = (~menuRef) => {
  let intl = ReactIntl.useIntl()

  <Mui.Drawer variant={Permanent} anchor={Left}>
    <Mui.List ref={menuRef->ReactDOM.Ref.domRef}>
      {Menu_Content.menuContent
      ->Array.mapWithIndex(({label, icon}, index) =>
        <Mui.ListItem key={`menu-item-${index->Int.toString}`}>
          <Mui.ListItemButton selected={index == 0 ? true : false}>
            <Mui.ListItemIcon> icon </Mui.ListItemIcon>
            <Mui.ListItemText primary={intl->ReactIntl.Intl.formatMessage(label)->Jsx.string} />
          </Mui.ListItemButton>
        </Mui.ListItem>
      )
      ->Jsx.array}
    </Mui.List>
  </Mui.Drawer>
}
