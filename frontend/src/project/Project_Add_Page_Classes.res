let nameAndActive = Mui.Sx.array([
  Mui.Sx.Array.func(theme =>
    ReactDOM.Style.make(
      ~gridColumnGap=theme->MuiSpacingFix.spacing(2),
      (),
    )->MuiStyles.styleToSxArray
  ),
])

let list = (
  ~listElementTopPosition as _: option<int>=?,
  ~bottomBarHeight as _: option<int>=?,
  ~actionButtonsHeight as _: option<int>=?,
) =>
  Mui.Sx.array([
    Mui.Sx.Array.func(_theme =>
      ReactDOM.Style.make(~overflow="auto", ())->MuiStyles.styleToSxArray
    ),
  ])

let exercisesScrolling = [ReactDOM.Style.make(~overflow="auto", ())->MuiStyles.styleToSxArray]
