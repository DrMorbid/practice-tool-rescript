module Classes = {
  let appBar = Mui.Sx.obj({bottom: Number(0.), top: Unset, left: Number(0.), right: Unset})
  let button = Mui.Sx.array([
    Mui.Sx.Array.func(theme =>
      Mui.Sx.Array.dict(
        Dict.fromArray([
          ("&.Mui-selected", ({color: String(theme.palette.primary.light)}: Mui.System.props)),
        ]),
      )
    ),
    Mui.Sx.Array.func(theme => Mui.Sx.Array.obj({color: String(theme.palette.text.primary)})),
  ])
}

@react.component
let make = (~menuRef) => {
  let intl = ReactIntl.useIntl()

  <Mui.AppBar position={Fixed} sx=Classes.appBar ref={menuRef->ReactDOM.Ref.domRef}>
    <Mui.BottomNavigation showLabels=true value=0 onChange={(_event, _newValue) => {()}}>
      {Menu_Content.menuContent
      ->Array.mapWithIndex(({label, icon}, index) =>
        <Mui.BottomNavigationAction
          label={intl->ReactIntl.Intl.formatMessage(label)->Jsx.string}
          icon
          sx=Classes.button
          key={`menu-item-${index->Int.toString}`}
        />
      )
      ->Jsx.array}
    </Mui.BottomNavigation>
  </Mui.AppBar>
}
