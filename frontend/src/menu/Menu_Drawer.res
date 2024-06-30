@react.component
let make = (~menuRef) => {
  <Mui.Drawer variant={Permanent} anchor={Left}>
    <Mui.List ref={menuRef->ReactDOM.Ref.domRef}>
      {Menu_Content.menuContent
      ->Array.mapWithIndex(({label, icon}, index) =>
        <Mui.ListItem key={`menu-item-${index->Int.toString}`}>
          <Mui.ListItemButton>
            <Mui.ListItemIcon> icon </Mui.ListItemIcon>
            <Mui.ListItemText primary={label->Jsx.string} />
          </Mui.ListItemButton>
        </Mui.ListItem>
      )
      ->Jsx.array}
    </Mui.List>
  </Mui.Drawer>
}
