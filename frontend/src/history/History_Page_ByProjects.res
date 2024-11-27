open Message.History

module ByExercises = History_Page_ByExercises
module NotPracticed = History_Page_NotPracticed

@react.component
let make = (~historyStatistics: array<History_Type.historyStatisticsByProject>) => {
  let intl = ReactIntl.useIntl()

  historyStatistics
  ->Array.mapWithIndex(({projectName, practiceCount, byExercises, notPracticedExercises}, index) =>
    <Mui.Accordion key={`history-item-projects-${index->Int.toString}`}>
      <Mui.AccordionSummary expandIcon={<Icon.ExpandMore />}>
        {projectName->Jsx.string}
      </Mui.AccordionSummary>
      <Mui.AccordionDetails>
        <Mui.Box
          display={String("grid")}
          gridTemplateColumns={String("1fr")}
          gridTemplateRows={String("auto auto 1fr")}
          sx={App_Theme.Classes.itemGaps->Mui.Sx.array}>
          {intl
          ->ReactIntl.Intl.formatMessageWithValues(practiced, {"times": practiceCount})
          ->Jsx.string}
          <Mui.Box
            display={String("grid")}
            gridTemplateColumns={String("1fr")}
            gridTemplateRows={String("1fr")}>
            <ByExercises byExercises />
          </Mui.Box>
          <NotPracticed notPracticedExercises />
        </Mui.Box>
      </Mui.AccordionDetails>
    </Mui.Accordion>
  )
  ->Jsx.array
}
