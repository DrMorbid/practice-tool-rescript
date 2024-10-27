@react.component
let make = (~exercisesCounts, ~onChange, ~exercisesCount as value=?, ~disabled=false) => {
  let intl = ReactIntl.useIntl()

  <Mui.FormControl>
    <Mui.InputLabel htmlFor="exercise-count-selection">
      {intl->ReactIntl.Intl.formatMessage(Message.Session.exerciseCount)->Jsx.string}
    </Mui.InputLabel>
    <Mui.NativeSelect
      inputProps={name: "exerciseCount", id: "exercise-count-selection"} ?value disabled onChange>
      {exercisesCounts
      ->Array.mapWithIndex((exerciseCount, index) =>
        <option
          value={exerciseCount->Int.toString}
          key={`exercise-count-selection-${index->Int.toString}`}>
          {exerciseCount->Jsx.int}
        </option>
      )
      ->Jsx.array}
    </Mui.NativeSelect>
  </Mui.FormControl>
}
