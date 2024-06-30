module Classes = {
  let appBar = Mui.Sx.obj({bottom: Number(0.), top: Unset, left: Number(0.), right: Unset})
}

@react.component
let make = (~menuRef) => {
  <Mui.AppBar position={Fixed} sx=Classes.appBar ref={menuRef->ReactDOM.Ref.domRef}>
    <Mui.BottomNavigation showLabels=true value=0 onChange={(_event, _newValue) => {()}}>
      <Mui.BottomNavigationAction label={"Practice"->Jsx.string} icon={<Icon.MusicNoteTwoTone />} />
      <Mui.BottomNavigationAction label={"Manage"->Jsx.string} icon={<Icon.BuildTwoTone />} />
    </Mui.BottomNavigation>
  </Mui.AppBar>
}
