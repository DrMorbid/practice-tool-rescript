let nameAndActive = Mui.Sx.array([
  Mui.Sx.Array.func(theme =>
    ReactDOM.Style.make(
      ~gridColumnGap=theme->MuiSpacingFix.spacing(2),
      (),
    )->MuiStyles.styleToSxArray
  ),
])
