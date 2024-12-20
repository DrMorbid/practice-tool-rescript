type windowDimensions = {
  width: int,
  height: int,
}

let getWindowDimensions = () => {
  width: Webapi.Dom.window->Webapi.Dom.Window.innerWidth,
  height: Webapi.Dom.window->Webapi.Dom.Window.innerHeight,
}

let useWindowDimensions = () => {
  let (windowDimensions, setWindowDimensions) = React.useState(() => None)

  React.useEffect(() => {
    let handleResize = _ => setWindowDimensions(_ => Some(getWindowDimensions()))

    Webapi.Dom.window->Webapi.Dom.Window.addEventListener("resize", handleResize)

    Some(() => Webapi.Dom.window->Webapi.Dom.Window.removeEventListener("resize", handleResize))
  }, [])

  windowDimensions
}
