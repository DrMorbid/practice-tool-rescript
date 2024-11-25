open Message.History
open Dayjs

@react.component
let default = () => {
  let (selectedDate, setSelectedDate) = React.useState(() => Date.make()->dayjsFromDate)
  let (historyStatistics, setHistoryStatistics) = React.useState(() =>
    Util.Fetch.Response.NotStarted
  )
  let intl = ReactIntl.useIntl()
  let auth = ReactOidcContext.useAuth()
  let router = Next.Navigation.useRouter()

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

  Console.log2("FKR: loaded history: historyStatistics=%o", historyStatistics)
  <>
    <Snackbar
      isOpen={historyStatistics->Util.Fetch.Response.isError}
      severity={Error}
      title={Message(Message.History.couldNotLoadHistory)}
      body=?{historyStatistics
      ->Util.Fetch.Response.errorToOption
      ->Belt.Option.map(({message}) => Text.String(message))}
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
          gridTemplateRows={String("1fr")}>
          <MuiX.DatePicker
            label={intl->ReactIntl.Intl.formatMessage(selectStartDate)}
            value=selectedDate
            onChange={selectedDate => setSelectedDate(_ => selectedDate)}
            maxDate={Date.make()->dayjsFromDate}
          />
        </Mui.Box>
      </Common.PageContent>
    </Page>
  </>
}
