open Message.History

@react.component
let make = (~byTempos: array<History_Type.historyStatisticsByTempo>) => {
  let intl = ReactIntl.useIntl()

  byTempos
  ->Array.mapWithIndex(({tempo, practiceCount}, index) =>
    <Mui.Accordion key={`history-item-tempos-${index->Int.toString}`}>
      <Mui.AccordionSummary expandIcon={<Icon.ExpandMore />}>
        {tempo->Exercise.Util.tempoToString(~intl)->Jsx.string}
      </Mui.AccordionSummary>
      <Mui.AccordionDetails>
        {intl
        ->ReactIntl.Intl.formatMessageWithValues(practiced, {"times": practiceCount})
        ->Jsx.string}
      </Mui.AccordionDetails>
    </Mui.Accordion>
  )
  ->Jsx.array
}
