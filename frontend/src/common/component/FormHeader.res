@react.component
let make = (~message) => {
  let intl = ReactIntl.useIntl()

  <Mui.Typography variant={H4} color={SecondaryMain}>
    {intl->ReactIntl.Intl.formatMessage(message)->Jsx.string}
  </Mui.Typography>
}
