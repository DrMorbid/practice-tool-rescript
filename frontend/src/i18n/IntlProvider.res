@react.component
let make = (~children) => {
  let locale = Store.useStoreWithSelector(({locale}) => locale)

  React.useEffect(() => {
    let {language} = Webapi.Dom.window->Webapi.Dom.Window.navigator
    Store.dispatch(Store.Action.StoreLocale(Intl.Locale.make(language)))

    None
  }, [Webapi.Dom.window->Webapi.Dom.Window.navigator])

  <ReactIntl.IntlProvider
    locale={locale->Intl.Locale.baseName} messages={locale->Translation.getTranslation}>
    {children}
  </ReactIntl.IntlProvider>
}
