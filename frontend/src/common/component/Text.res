type t = String(string) | Message(ReactIntl.message) | Nothing

@react.component
let make = (~text) => {
  let intl = ReactIntl.useIntl()

  switch text {
  | String(string) => string->Jsx.string
  | Message(message) => intl->ReactIntl.Intl.formatMessage(message)->Jsx.string
  | Nothing => Jsx.null
  }
}
