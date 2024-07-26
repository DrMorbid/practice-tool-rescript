module Classes = {
  let form = [
    Mui.Sx.Array.func(theme =>
      ReactDOM.Style.make(~gridRowGap=theme->MuiSpacingFix.spacing(2), ())->MuiStyles.styleToSxArray
    ),
  ]
}

@react.component
let make = (~onSubmit, ~onCancel, ~actionButtonsRef=?, ~children) => {
  let intl = ReactIntl.useIntl()

  <form onSubmit>
    <Mui.Box
      display={String("grid")}
      alignContent={String("space-between")}
      sx={App_Theme.Classes.maxHeight->Array.concat(Classes.form)->Mui.Sx.array}>
      <Mui.Box display={String("grid")} sx={Classes.form->Mui.Sx.array}> children </Mui.Box>
      <Mui.Box
        display={String("grid")}
        gridAutoFlow={String("column")}
        gridAutoColumns={String("1fr")}
        gridAutoRows={String("1fr")}
        ref=?{actionButtonsRef->Option.map(ReactDOM.Ref.domRef)}>
        <Mui.Button onClick=onCancel variant={Outlined}>
          {intl->ReactIntl.Intl.formatMessage(Message.Button.cancel)->Jsx.string}
        </Mui.Button>
        <Mui.Button type_=Submit variant={Contained}>
          {intl->ReactIntl.Intl.formatMessage(Message.Button.save)->Jsx.string}
        </Mui.Button>
      </Mui.Box>
    </Mui.Box>
  </form>
}
