let nameAndActive = Mui.Sx.array([
  Mui.Sx.Array.func(theme =>
    ReactDOM.Style.make(
      ~gridColumnGap=theme->MuiSpacingFix.spacing(2),
      (),
    )->MuiStyles.styleToSxArray
  ),
])

let list = (
  ~listElementTopPosition: option<int>=?,
  ~bottomBarHeight: option<int>=?,
  ~actionButtonsHeight: option<int>=?,
) =>
  Mui.Sx.array([
    Mui.Sx.Array.func(theme =>
      ReactDOM.Style.make(
        ~overflow="auto",
        ~height=`calc(100vh - ${listElementTopPosition
          ->Option.map(Int.toString(_))
          ->Option.getOr("0")}px - ${bottomBarHeight
          ->Option.map(Int.toString(_))
          ->Option.getOr("0")}px - ${actionButtonsHeight
          ->Option.map(Int.toString(_))
          ->Option.getOr("0")}px - ${theme->MuiSpacingFix.spacing(5)})`,
        (),
      )->MuiStyles.styleToSxArray
    ),
  ])
