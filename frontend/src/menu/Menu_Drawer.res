@react.component
let make = (~menuRef) => {
  <Mui.Drawer variant={Permanent} anchor={Left}>
    <Mui.List ref={menuRef->ReactDOM.Ref.domRef}>
      <Mui.ListItem>
        <Mui.ListItemButton>
          <Mui.ListItemIcon>
            <Icon.MusicNoteTwoTone />
          </Mui.ListItemIcon>
          <Mui.ListItemText primary={"Practice"->Jsx.string} />
        </Mui.ListItemButton>
      </Mui.ListItem>
      <Mui.ListItem>
        <Mui.ListItemButton>
          <Mui.ListItemIcon>
            <Icon.BuildTwoTone />
          </Mui.ListItemIcon>
          <Mui.ListItemText primary={"Manage"->Jsx.string} />
        </Mui.ListItemButton>
      </Mui.ListItem>
    </Mui.List>
  </Mui.Drawer>
}
