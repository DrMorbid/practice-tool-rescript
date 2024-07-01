open Language

@react.component
let make = (~children) => {
  let (defaultLanguage, _) = React.useState(() => Cs)

  <ReactIntl.IntlProvider
    defaultLocale={defaultLanguage->toString}
    locale={defaultLanguage->toString}
    messages={defaultLanguage->Translation.getTranslation}>
    {children}
  </ReactIntl.IntlProvider>
}
