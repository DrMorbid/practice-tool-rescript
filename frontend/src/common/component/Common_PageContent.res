@react.component
let make = (
  ~onPrimary=?,
  ~onSecondary=?,
  ~primaryType=?,
  ~header,
  ~gridTemplateRows,
  ~actionPending=false,
  ~primaryButtonLabel=Message.Button.save,
  ~secondaryButtonLabel=Message.Button.cancel,
  ~actionButtonsRef=?,
  ~fixedHeight=?,
  ~children,
) => {
  let intl = ReactIntl.useIntl()

  <Mui.Box
    sx={Mui.Sx.array([
      Mui.Sx.Array.obj({
        height: String(
          fixedHeight->Option.map(height => height->Float.toString ++ "px")->Option.getOr("100%"),
        ),
      }),
      App_Theme.Classes.scrollable,
    ])}>
    <Mui.Box
      display={String("grid")}
      alignContent={String("space-between")}
      gridTemplateColumns={String("1fr")}
      gridTemplateRows={String(gridTemplateRows)}
      sx={App_Theme.Classes.maxHeight
      ->Array.concat(App_Theme.Classes.itemGaps)
      ->Mui.Sx.array}>
      {header}
      {children}
      {if onPrimary->Belt.Option.isNone && onSecondary->Belt.Option.isNone {
        Jsx.null
      } else {
        <Mui.Box
          display={String("grid")}
          gridAutoFlow={String("column")}
          gridAutoColumns={String("1fr")}
          gridAutoRows={String("1fr")}
          ref=?{actionButtonsRef->Option.map(ReactDOM.Ref.domRef)}>
          <Mui.Button onClick=?onSecondary variant={Outlined} disabled=actionPending>
            {intl->ReactIntl.Intl.formatMessage(secondaryButtonLabel)->Jsx.string}
          </Mui.Button>
          <Mui.Button
            type_=?primaryType onClick=?onPrimary variant={Contained} disabled=actionPending>
            {intl->ReactIntl.Intl.formatMessage(primaryButtonLabel)->Jsx.string}
          </Mui.Button>
        </Mui.Box>
      }}
    </Mui.Box>
  </Mui.Box>
}
