@react.component
let make = (~projectNames, ~onChange, ~projectName as value=?, ~disabled=false) => {
  let intl = ReactIntl.useIntl()

  <Mui.FormControl>
    <Mui.InputLabel htmlFor="project-name-selection">
      {intl->ReactIntl.Intl.formatMessage(Message.Session.projectName)->Jsx.string}
    </Mui.InputLabel>
    <Mui.NativeSelect
      inputProps={name: "projectName", id: "project-name-selection"} ?value onChange disabled>
      {projectNames
      ->Array.mapWithIndex((projectName, index) =>
        <option value=projectName key={`project-name-selection-${index->Int.toString}`}>
          {projectName->Jsx.string}
        </option>
      )
      ->Jsx.array}
    </Mui.NativeSelect>
  </Mui.FormControl>
}
