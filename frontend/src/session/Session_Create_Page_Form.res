module Content = ReactHookForm.Make({
  type t = Session_Type.t
})

module Input = {
  let defaultValues: Session_Type.t = {
    projectName: "",
    exerciseCount: 0,
  }

  module ProjectName = Content.MakeInput({
    type t = string
    let name = "projectName"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  let renderProjectName = (~intl, ~projectNames, ~onChange, form) =>
    form->ProjectName.renderWithRegister(
      <Mui.FormControl>
        <Mui.InputLabel htmlFor="project-name-selection">
          {intl->ReactIntl.Intl.formatMessage(Message.Session.projectName)->Jsx.string}
        </Mui.InputLabel>
        <Mui.NativeSelect inputProps={name: "projectName", id: "project-name-selection"} onChange>
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

  module ExerciseCount = Content.MakeInput({
    type t = int
    let name = "exerciseCount"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  let renderExerciseCount = (~disabled=false, ~intl, ~exercisesCount, form) =>
    form->ExerciseCount.renderWithRegister(
      <Mui.FormControl>
        <Mui.InputLabel htmlFor="exercise-count-selection">
          {intl->ReactIntl.Intl.formatMessage(Message.Session.exerciseCount)->Jsx.string}
        </Mui.InputLabel>
        <Mui.NativeSelect
          inputProps={name: "exerciseCount", id: "exercise-count-selection"} disabled>
          {exercisesCount
          ->Array.mapWithIndex((exerciseCount, index) =>
            <option
              value={exerciseCount->Int.toString}
              key={`exercise-count-selection-${index->Int.toString}`}>
              {exerciseCount->Jsx.int}
            </option>
          )
          ->Jsx.array}
        </Mui.NativeSelect>
      </Mui.FormControl>,
      ~config=ExerciseCount.makeRule({required: true}),
      (),
    )
}
