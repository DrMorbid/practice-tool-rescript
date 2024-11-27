open Message.History

@react.component
let make = (~notPracticedExercises) => {
  let intl = ReactIntl.useIntl()

  <Mui.Accordion>
    <Mui.AccordionSummary expandIcon={<Icon.ExpandMore />}>
      {intl->ReactIntl.Intl.formatMessage(unpracticedExercises)->Jsx.string}
    </Mui.AccordionSummary>
    <Mui.AccordionDetails>
      {if notPracticedExercises->Array.length == 0 {
        <Mui.Typography>
          {intl
          ->ReactIntl.Intl.formatMessage(noUnpracticedExercises)
          ->Jsx.string}
        </Mui.Typography>
      } else {
        <Mui.List>
          {notPracticedExercises
          ->Array.mapWithIndex((exerciseName, index) =>
            <Mui.ListItem key={`not-practiced-exercises-${index->Int.toString}`}>
              <Mui.ListItemText primary={exerciseName->Jsx.string} />
            </Mui.ListItem>
          )
          ->Jsx.array}
        </Mui.List>
      }}
    </Mui.AccordionDetails>
  </Mui.Accordion>
}
