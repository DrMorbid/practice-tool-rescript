module Classes = {
  let deleteButton = Mui.Sx.array([
    Mui.Sx.Array.func(theme => {
      Mui.Sx.Array.obj({
        position: String("fixed"),
        top: String(theme->MuiSpacingFix.spacing(2)),
        right: String(theme->MuiSpacingFix.spacing(2)),
      })
    }),
  ])
}

@react.component
let make = (~onClick, ~disabled=false) => {
  <Mui.Fab
    onClick={if disabled {
      _ => ()
    } else {
      onClick
    }}
    color={Secondary}
    disabled
    sx={Classes.deleteButton}>
    <Icon.Delete />
  </Mui.Fab>
}
