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
  let menuRef = React.useRef(Nullable.null)
  let auth = ReactOidcContext.useAuth()
  let bottomBarHeight = Store.useStoreWithSelector(({?bottomBarHeight}) => bottomBarHeight)
  let drawerWidth = Store.useStoreWithSelector(({?drawerWidth}) => drawerWidth)

  React.useEffect(() => {
    let menuElement =
      menuRef.current
      ->Nullable.toOption
      ->Option.map(current => current->ReactDOM.domElementToObj)

    if isMdUp {
      menuElement
      ->Option.map(menuElement => menuElement["offsetWidth"])
      ->Option.forEach(width => Store.dispatch(StoreDrawerWidth(width)))

      Store.dispatch(ResetBottomBarHeight)
    } else {
      menuElement
      ->Option.map(menuElement => menuElement["offsetHeight"])
      ->Option.forEach(height => Store.dispatch(StoreBottomBarHeight(height)))

      Store.dispatch(ResetDrawerWidth)
    }

    None
  }, (menuRef, isMdUp))

  <>
    <Mui.Container
      maxWidth={False} sx={Classes.container(isMdUp, ~bottomBarHeight?, ~drawerWidth?)}>
      {children}
    </Mui.Container>
    {auth.isAuthenticated
      ? isMdUp ? <Menu.Drawer menuRef /> : <Menu.BottomBar menuRef />
      : Jsx.null}
  </>
}
