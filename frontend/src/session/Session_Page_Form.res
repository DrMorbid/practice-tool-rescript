module Content = ReactHookForm.Make({
  type t = Session_Type.t
})

module Input = {
  let defaultValues: Session_Type.t = {
    projectName: "",
  }

  module ProjectName = Content.MakeInput({
    type t = string
    let name = "projectName"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  let renderProjectName = (~intl, ~projectNames, form) =>
    form->ProjectName.renderWithRegister(
      <Mui.FormControl>
        <Mui.InputLabel htmlFor="project-name-selection">
          {intl->ReactIntl.Intl.formatMessage(Message.Session.projectName)->Jsx.string}
        </Mui.InputLabel>
        <Mui.NativeSelect inputProps={name: "projectName", id: "project-name-selection"}>
          {projectNames
          ->Array.mapWithIndex((projectName, index) =>
            <option value=projectName key={`project-name-selection-${index->Int.toString}`}>
              {projectName->Jsx.string}
            </option>
          )
          ->Jsx.array}
        </Mui.NativeSelect>
      </Mui.FormControl>,
      ~config=ProjectName.makeRule({required: true}),
      (),
    )
}
