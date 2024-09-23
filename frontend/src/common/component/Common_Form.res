module Classes = {
  let formGaps = [
    Mui.Sx.Array.func(theme =>
      ReactDOM.Style.make(~gridRowGap=theme->MuiSpacingFix.spacing(2), ())->MuiStyles.styleToSxArray
    ),
  ]
  let formGapsVertical = [
    Mui.Sx.Array.func(theme =>
      ReactDOM.Style.make(
        ~gridColumnGap=theme->MuiSpacingFix.spacing(2),
        (),
      )->MuiStyles.styleToSxArray
    ),
  ]
}

@react.component
let make = (
  ~onSubmit,
  ~onCancel,
  ~header,
  ~gridTemplateRows,
  ~submitPending=false,
  ~actionButtonsRef=?,
  ~fixedHeight=?,
  ~children,
) => {
  let intl = ReactIntl.useIntl()

  <form onSubmit>
    <Mui.Box
      sx={Mui.Sx.obj({
        height: String(
          fixedHeight->Option.map(height => height->Float.toString ++ "px")->Option.getOr("100%"),
        ),
      })}>
      <Mui.Box
        display={String("grid")}
        alignContent={String("space-between")}
        gridTemplateColumns={String("1fr")}
        gridTemplateRows={String(gridTemplateRows)}
        sx={App_Theme.Classes.maxHeight
        ->Array.concat(Classes.formGaps)
        ->Mui.Sx.array}>
        {header}
        {children}
        <Mui.Box
          display={String("grid")}
          gridAutoFlow={String("column")}
          gridAutoColumns={String("1fr")}
          gridAutoRows={String("1fr")}
          ref=?{actionButtonsRef->Option.map(ReactDOM.Ref.domRef)}>
          <Mui.Button onClick=onCancel variant={Outlined} disabled=submitPending>
            {intl->ReactIntl.Intl.formatMessage(Message.Button.cancel)->Jsx.string}
          </Mui.Button>
          <Mui.Button type_=Submit variant={Contained} disabled=submitPending>
            {intl->ReactIntl.Intl.formatMessage(Message.Button.save)->Jsx.string}
          </Mui.Button>
        </Mui.Box>
      </Mui.Box>
    </Mui.Box>
  </form>
}
