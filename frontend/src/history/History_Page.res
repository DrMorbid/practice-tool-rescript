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
              gridTemplateColumns={String("1fr")}
              gridTemplateRows={String("auto auto 1fr")}
              sx={App_Theme.Classes.itemGaps->Mui.Sx.array}>
              <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
              <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
              <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
            </Mui.Box>
          | Ok(historyStatistics) =>
            <Mui.Box
              display={String("grid")}
              gridTemplateColumns={String("1fr")}
              gridTemplateRows={String("1fr")}>
              {historyStatistics
              ->Array.mapWithIndex(({projectName, practiceCount, byExercises}, index) =>
                <Mui.Accordion key={`history-item-projects-${index->Int.toString}`}>
                  <Mui.AccordionSummary expandIcon={<Icon.ExpandMore />}>
                    {projectName->Jsx.string}
                  </Mui.AccordionSummary>
                  <Mui.AccordionDetails>
                    <Mui.Box
                      display={String("grid")}
                      gridTemplateColumns={String("1fr")}
                      gridTemplateRows={String("auto 1fr")}
                      sx={App_Theme.Classes.itemGaps->Mui.Sx.array}>
                      {intl
                      ->ReactIntl.Intl.formatMessageWithValues(practiced, {"times": practiceCount})
                      ->Jsx.string}
                      <Mui.Box
                        display={String("grid")}
                        gridTemplateColumns={String("1fr")}
                        gridTemplateRows={String("1fr")}>
                        {byExercises
                        ->Array.mapWithIndex(({exerciseName, practiceCount, byTempos}, index) =>
                          <Mui.Accordion key={`history-item-exercises-${index->Int.toString}`}>
                            <Mui.AccordionSummary expandIcon={<Icon.ExpandMore />}>
                              {exerciseName->Jsx.string}
                            </Mui.AccordionSummary>
                            <Mui.AccordionDetails>
                              <Mui.Box
                                display={String("grid")}
                                gridTemplateColumns={String("1fr")}
                                gridTemplateRows={String("auto 1fr")}
                                sx={App_Theme.Classes.itemGaps->Mui.Sx.array}>
                                {intl
                                ->ReactIntl.Intl.formatMessageWithValues(
                                  practiced,
                                  {"times": practiceCount},
                                )
                                ->Jsx.string}
                                <Mui.Box
                                  display={String("grid")}
                                  gridTemplateColumns={String("1fr")}
                                  gridTemplateRows={String("1fr")}>
                                  {byTempos
                                  ->Array.mapWithIndex(
                                    ({tempo, practiceCount}, index) =>
                                      <Mui.Accordion
                                        key={`history-item-tempos-${index->Int.toString}`}>
                                        <Mui.AccordionSummary expandIcon={<Icon.ExpandMore />}>
                                          {tempo->Exercise.Util.tempoToString(~intl)->Jsx.string}
                                        </Mui.AccordionSummary>
                                        <Mui.AccordionDetails>
                                          {intl
                                          ->ReactIntl.Intl.formatMessageWithValues(
                                            practiced,
                                            {"times": practiceCount},
                                          )
                                          ->Jsx.string}
                                        </Mui.AccordionDetails>
                                      </Mui.Accordion>,
                                  )
                                  ->Jsx.array}
                                </Mui.Box>
                              </Mui.Box>
                            </Mui.AccordionDetails>
                          </Mui.Accordion>
                        )
                        ->Jsx.array}
                      </Mui.Box>
                    </Mui.Box>
                  </Mui.AccordionDetails>
                </Mui.Accordion>
              )
              ->Jsx.array}
            </Mui.Box>
          | NotStarted | Error(_) => Jsx.null
          }}
        </Mui.Box>
      </Common.PageContent>
    </Page>
  </>
}
