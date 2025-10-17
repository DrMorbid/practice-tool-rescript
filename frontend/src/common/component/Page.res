module Classes = {
  let container = (~spaceOnTop, ~spaceOnBottom, ~justifyItems) => {
    let applyPadding = theme => theme->MuiSpacingFix.spacing(3)

    [[("justify-items", justifyItems)]->Dict.fromArray->MuiStyles.dictToSxArray]
    ->Array.concat(App_Theme.Classes.maxHeight)
    ->Array.concat(
      spaceOnTop
        ? [Mui.Sx.Array.func(theme => Mui.Sx.Array.obj({paddingTop: String(theme->applyPadding)}))]
        : [],
    )
    ->Array.concat(
      spaceOnBottom
        ? [
            Mui.Sx.Array.func(theme =>
              Mui.Sx.Array.obj({paddingBottom: String(theme->applyPadding)})
            ),
          ]
        : [],
    )
  }
}

@react.component
let make = (
  ~alignContent: Mui.System.Value.t=String("space-evenly"),
  ~justifyItems="center",
  ~gridAutoRows: option<Mui.System.Value.t>=?,
  ~spaceOnTop=false,
  ~spaceOnBottom=false,
  ~pageRef=?,
  ~sx=?,
  ~children,
) => {
  <Mui.Box
    display={String("grid")}
    ?gridAutoRows
    alignContent
    sx={Classes.container(~spaceOnTop, ~spaceOnBottom, ~justifyItems)
    ->Array.concat(sx->Option.getOr([]))
    ->Mui.Sx.array}
    ref=?{pageRef->Option.map(ReactDOM.Ref.domRef)}>
    {children}
  </Mui.Box>
}
