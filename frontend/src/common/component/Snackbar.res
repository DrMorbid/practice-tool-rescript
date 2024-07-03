module Classes = {}

@react.component
let make = (
  ~isOpen=true,
  ~severity: Mui.Alert.severity=Error,
  ~title: option<Text.t>=?,
  ~body: option<Text.t>=?,
) => {
  let (open_, setOpen_) = React.useState(() => isOpen)
  let isSmUp = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smUp)

  React.useEffect(() => {
    setOpen_(_ => isOpen)

    None
  }, [isOpen])

  <Mui.Snackbar
    open_
    anchorOrigin={if isSmUp {
      {vertical: Top, horizontal: Right}
    } else {
      {vertical: Bottom, horizontal: Center}
    }}>
    <Mui.Alert
      variant={Filled}
      severity
      onClose={_ => setOpen_(_ => false)}
      sx={Mui.Sx.array(isSmUp ? [] : App_Theme.Classes.maxWidth)}>
      <Mui.AlertTitle>
        <Text
          text={title->Option.getOr(
            switch severity {
            | Success => Message(Message.Alert.defaultTitleSuccess)
            | Info => Message(Message.Alert.defaultTitleInfo)
            | Warning => Message(Message.Alert.defaultTitleWarning)
            | Error => Message(Message.Alert.defaultTitleError)
            },
          )}
        />
      </Mui.AlertTitle>
      <Text text={body->Option.getOr(Nothing)} />
    </Mui.Alert>
  </Mui.Snackbar>
}
