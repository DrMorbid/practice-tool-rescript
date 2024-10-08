let maxHeight = [
  Mui.Sx.Array.obj({
    height: String("100%"),
  }),
]
let maxWidth = [Mui.Sx.Array.obj({width: String("100%")})]
let itemGaps = [
  Mui.Sx.Array.func(theme =>
    ReactDOM.Style.make(~gridRowGap=theme->MuiSpacingFix.spacing(2), ())->MuiStyles.styleToSxArray
  ),
]
let itemGapsHorizontal = [
  Mui.Sx.Array.func(theme =>
    ReactDOM.Style.make(
      ~gridColumnGap=theme->MuiSpacingFix.spacing(2),
      (),
    )->MuiStyles.styleToSxArray
  ),
]
