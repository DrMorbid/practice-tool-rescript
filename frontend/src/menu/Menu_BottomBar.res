module Classes = {
  let appBar = Mui.Sx.obj({bottom: Number(0.), top: Unset, left: Number(0.), right: Unset})
}

@react.component
let make = (~menuRef) => {
  <Mui.AppBar position={Fixed} sx=Classes.appBar ref={menuRef->ReactDOM.Ref.domRef}>
    <Mui.BottomNavigation showLabels=true value=0 onChange={(_event, _newValue) => {()}}>
      {Menu_Content.menuContent
      ->Array.mapWithIndex(({label, icon}, index) =>
        <Mui.BottomNavigationAction
          label={label->Jsx.string} icon key={`menu-item-${index->Int.toString}`}
        />
      )
      ->Jsx.array}
    </Mui.BottomNavigation>
  </Mui.AppBar>
}
