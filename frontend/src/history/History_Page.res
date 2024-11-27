open Message.History
open Dayjs

module ByProjects = History_Page_ByProjects

@react.component
let default = () => {
  let (selectedDate, setSelectedDate) = React.useState(() => Date.make()->dayjsFromDate)
  let (historyStatistics, setHistoryStatistics) = React.useState(() =>
    Util.Fetch.Response.NotStarted
  )
  let intl = ReactIntl.useIntl()
  let auth = ReactOidcContext.useAuth()
  let router = Next.Navigation.useRouter()
  let isSmUp = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smUp)
  let isLgUp = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.lgUp)
  let locale = Store.useStoreWithSelector(({locale}) => locale)

  React.useEffect(() => {
    setHistoryStatistics(_ => Pending)

    Util.Fetch.fetch(
      History(selectedDate),
      ~method=Get,
      ~auth,
      ~responseDecoder=History_Type.historyStatistics_decode,
      ~router,
    )
    ->Promise.thenResolve(result =>
      switch result {
      | Ok(historyStatistics) => setHistoryStatistics(_ => Ok(historyStatistics))
      | Error(error) => setHistoryStatistics(_ => Error(error))
      }
    )
    ->ignore

    None
  }, [selectedDate])

  <>
    <Snackbar
      isOpen={historyStatistics->Util.Fetch.Response.isError}
      severity={Error}
      title={Message(Message.History.couldNotLoadHistory)}
      body=?{historyStatistics
      ->Util.Fetch.Response.errorToOption
      ->Option.map(({message}) => Text.String(message))}
    />
    <Snackbar
      isOpen={historyStatistics
      ->Util.Fetch.Response.mapSuccess(statistics => statistics->Array.length == 0)
      ->Util.Fetch.Response.toOption
      ->Option.getOr(false)}
      severity={Info}
      title={String(
        intl->ReactIntl.Intl.formatMessageWithValues(
          Message.History.noHistoryForThePeroid,
          {
            "dateFrom": Intl.DateTimeFormat.make(
              ~locales=[locale->Intl.Locale.baseName],
              ~options={dateStyle: #medium},
            )->Intl.DateTimeFormat.format(selectedDate->toDate),
          },
        ),
      )}
    />
    <Page alignContent={Stretch} spaceOnTop=true spaceOnBottom=true justifyItems="stretch">
      <Common.PageContent
        header={<PageHeader message=historyTitle />}
        gridTemplateRows={"auto auto 1fr"}
        actionPending=false>
        <Mui.Box
          display={String("grid")}
          alignContent={String("start")}
          gridTemplateColumns={String("1fr")}
          gridTemplateRows={String("auto 1fr")}
          sx={App_Theme.Classes.itemGaps->Mui.Sx.array}>
          <MuiX.DatePicker
            label={intl->ReactIntl.Intl.formatMessage(selectStartDate)}
            value=selectedDate
            onChange={selectedDate => setSelectedDate(_ => selectedDate)}
            maxDate={Date.make()->dayjsFromDate}
          />
          {switch historyStatistics {
          | Pending =>
            <Mui.Box
              display={String("grid")}
              gridTemplateColumns={String(isLgUp ? "1fr 1fr 1fr" : isSmUp ? "1fr 1fr" : "1fr")}
              gridTemplateRows={String("1fr")}
              alignItems={Baseline}>
              <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
              <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
              <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
            </Mui.Box>
          | Ok(historyStatistics) =>
            <Mui.Box
              display={String("grid")}
              gridTemplateColumns={String(isLgUp ? "1fr 1fr 1fr" : isSmUp ? "1fr 1fr" : "1fr")}
              gridTemplateRows={String("1fr")}
              alignItems={Baseline}>
              <ByProjects historyStatistics />
            </Mui.Box>
          | NotStarted | Error(_) => Jsx.null
          }}
        </Mui.Box>
      </Common.PageContent>
    </Page>
  </>
}
