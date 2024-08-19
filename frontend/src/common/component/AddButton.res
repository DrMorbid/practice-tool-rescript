module Classes = {
  let addButton = (~bottomBarHeight=?, ~bottomPosition, ~bottomSpacing) =>
    Mui.Sx.array([
      Mui.Sx.Array.func(theme => {
        Mui.Sx.Array.obj({
          position: String("fixed"),
          bottom: String(
            `calc(${bottomBarHeight
              ->Option.map(Int.toString(_))
              ->Option.getOr("0")}px + ${theme->MuiSpacingFix.spacing(
                bottomSpacing,
              )} + ${bottomPosition})`,
          ),
          right: String(theme->MuiSpacingFix.spacing(2)),
        })
      }),
    ])
}

@react.component
let make = (~onClick, ~bottomPosition="0px", ~bottomSpacing=2, ~disabled=false) => {
  let bottomBarHeight = Store.useStoreWithSelector(({?bottomBarHeight}) => bottomBarHeight)

  <Mui.Fab
    onClick={if disabled {
      _ => ()
    } else {
      onClick
    }}
    color=Primary
    disabled
    sx={Classes.addButton(~bottomBarHeight?, ~bottomPosition, ~bottomSpacing)}>
    <Icon.Add />
  </Mui.Fab>
}
