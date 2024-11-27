open Message.History

module ByTempos = History_Page_ByTempos

@react.component
let make = (~byExercises: array<History_Type.historyStatisticsByExercise>) => {
  let intl = ReactIntl.useIntl()

  byExercises
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
          ->ReactIntl.Intl.formatMessageWithValues(practiced, {"times": practiceCount})
          ->Jsx.string}
          <Mui.Box
            display={String("grid")}
            gridTemplateColumns={String("1fr")}
            gridTemplateRows={String("1fr")}>
            <ByTempos byTempos />
          </Mui.Box>
        </Mui.Box>
      </Mui.AccordionDetails>
    </Mui.Accordion>
  )
  ->Jsx.array
}
