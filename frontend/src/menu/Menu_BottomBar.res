module Classes = {
  let appBar = Mui.Sx.obj({bottom: Number(0.), top: Unset, left: Number(0.), right: Unset})
}

@react.component
let make = (~bottomBarRef) => {
  <Mui.AppBar position={Fixed} sx=Classes.appBar ref={bottomBarRef->ReactDOM.Ref.domRef}>
    <Mui.BottomNavigation showLabels=true value=0 onChange={(_event, _newValue) => {()}}>
      <Mui.BottomNavigationAction label={"Practice"->Jsx.string} />
      <Mui.BottomNavigationAction label={"Manage"->Jsx.string} />
      <Mui.BottomNavigationAction label={"History"->Jsx.string} />
    </Mui.BottomNavigation>
  </Mui.AppBar>
}
