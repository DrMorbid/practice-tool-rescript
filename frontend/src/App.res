@@directive("'use client';")

module Classes = {
  let container = (~bottomBarHeight=?, ~drawerWidth=?, isMdUp) => {
    let styles = App_Theme.Classes.maxHeight

    let styles = if isMdUp {
      styles->Array.concat([
        Mui.Sx.Array.obj({
          marginLeft: String(`${drawerWidth->Option.map(Int.toString(_))->Option.getOr("0")}px`),
          width: Unset,
        }),
      ])
    } else {
      styles->Array.concat([
        Mui.Sx.Array.obj({
          paddingBottom: String(
            `${bottomBarHeight->Option.map(Int.toString(_))->Option.getOr("0")}px`,
          ),
        }),
      ])
    }

    styles->Mui.Sx.array
  }
}

@react.component
let make = (~children) => {
  let isMdUp = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.mdUp)
  let bottomBarHeight = Store.useStoreWithSelector(({?bottomBarHeight}) => bottomBarHeight)
  let drawerWidth = Store.useStoreWithSelector(({?drawerWidth}) => drawerWidth)

  <Mui.Container maxWidth={False} sx={Classes.container(isMdUp, ~bottomBarHeight?, ~drawerWidth?)}>
    {children}
  </Mui.Container>
}
