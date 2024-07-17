module Classes = {
  let addButton = (~bottomBarHeight, ~bottomPosition, ~bottomSpacing) =>
    Mui.Sx.array([
      Mui.Sx.Array.func(theme => {
        Mui.Sx.Array.obj({
          position: String("fixed"),
          bottom: String(
            `calc(${bottomBarHeight->Int.toString}px + ${theme->MuiSpacingFix.spacing(
                bottomSpacing,
              )} + ${bottomPosition})`,
          ),
          right: String(theme->MuiSpacingFix.spacing(2)),
        })
      }),
    ])
}

@react.component
let make = (~onClick, ~bottomPosition="0px", ~bottomSpacing=2) => {
  let bottomBarHeight = Store.useStoreWithSelector(({bottomBarHeight}) => bottomBarHeight)

  <Mui.Fab
    onClick color=Primary sx={Classes.addButton(~bottomBarHeight, ~bottomPosition, ~bottomSpacing)}>
    <Icon.Add />
  </Mui.Fab>
}
