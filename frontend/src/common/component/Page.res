module Classes = {
  let container = (~spaceOnTop, ~spaceOnBottom, ~justifyItems) =>
    Mui.Sx.array(
      [ReactDOM.Style.make(~justifyItems, ())->MuiStyles.styleToSxArray]
      ->Array.concat(App_Theme.Classes.maxHeight)
      ->Array.concat(
        spaceOnTop
          ? [
              Mui.Sx.Array.func(theme =>
                Mui.Sx.Array.obj({paddingTop: Number(theme.spacing(3)->Int.toFloat)})
              ),
            ]
          : [],
      )
      ->Array.concat(
        spaceOnBottom
          ? [
              Mui.Sx.Array.func(theme =>
                Mui.Sx.Array.obj({paddingBottom: Number(theme.spacing(3)->Int.toFloat)})
              ),
            ]
          : [],
      ),
    )
}

@react.component
let make = (
  ~alignContent: Mui.System.Value.t=String("space-evenly"),
  ~justifyItems="center",
  ~gridAutoRows: option<Mui.System.Value.t>=?,
  ~spaceOnTop=false,
  ~spaceOnBottom=false,
  ~children,
) => {
  <Mui.Box
    display={String("grid")}
    ?gridAutoRows
    alignContent
    sx={Classes.container(~spaceOnTop, ~spaceOnBottom, ~justifyItems)}>
    {children}
  </Mui.Box>
}
