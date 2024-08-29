open Project_Detail_Page_Classes

module Content = ReactHookForm.Make({
  type t = Project_Type.t
})

module Input = {
  let defaultValues: Project_Type.t = {
    name: "",
    active: true,
    exercises: [],
  }

  module Name = Content.MakeInput({
    type t = string
    let name = "name"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  let renderName = (~intl, ~key=?, form) =>
    form->Name.renderWithRegister(
      <Mui.TextField
        variant={Standard}
        required=true
        label={intl->ReactIntl.Intl.formatMessage(Message.Project.name)->Jsx.string}
        error={form->Name.error->Option.isSome}
        ?key
      />,
      ~config=Name.makeRule({required: true}),
      (),
    )

  module Active = Content.MakeInput({
    type t = bool
    let name = "active"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  let renderActive = (~intl, ~project: option<Project_Type.t>=?, ~key=?, form) =>
    form->Active.renderWithRegister(
      <Mui.FormControlLabel
        control={<Mui.Switch
          defaultChecked={project
          ->Option.map(({active}) => active)
          ->Option.getOr(defaultValues.active)}
        />}
        label={intl->ReactIntl.Intl.formatMessage(Message.Project.active)->Jsx.string}
        ?key
      />,
      (),
    )

  module Exercises = Content.MakeInputArray({
    type t = Exercise.Type.t
    let name = "exercises"
    let config = ReactHookForm.Rules.empty()
  })

  let renderExercises = (
    ~listRef,
    ~onExerciseClick,
    ~smDown,
    ~listElementTopPosition=?,
    ~bottomBarHeight=?,
    ~actionButtonsHeight=?,
    form,
  ) =>
    <Mui.List
      component={Mui.OverridableComponent.componentWithUnknownProps(component =>
        if smDown {
          <Mui.Box {...component} />
        } else {
          <Mui.Box
            {...component}
            display={String("grid")}
            gridAutoRows={String("max-content")}
            gridTemplateColumns={String("1fr 1fr")}
            alignItems={String("baseline")}
          />
        }
      )}
      sx={list(~listElementTopPosition?, ~bottomBarHeight?, ~actionButtonsHeight?)}
      ref={listRef->ReactDOM.Ref.domRef}>
      {form
      ->Exercises.getValue
      ->Array.toSorted(Exercise.Util.getOrdering)
      ->Array.mapWithIndex((exercise, index) =>
        <Mui.ListItemButton
          key={`exercise-${index->Int.toString}`}
          divider=true
          onClick={_ => onExerciseClick(~index, exercise)}>
          <Mui.ListItemIcon> {exercise->Exercise.Util.getStateIcon} </Mui.ListItemIcon>
          <Mui.ListItemText
            primary={exercise.name->Jsx.string}
            secondary={<Mui.Box
              display={String("grid")}
              gridAutoFlow={String("column")}
              gridAutoColumns={String("1fr")}
              gridAutoRows={String("1fr")}>
              <Mui.Box>
                {exercise.slowTempo
                ->Option.map(Exercise.Util.formatTempo)
                ->Option.map(Jsx.string)
                ->Option.getOr(Jsx.null)}
              </Mui.Box>
              <Mui.Box>
                {exercise.fastTempo
                ->Option.map(Exercise.Util.formatTempo)
                ->Option.map(Jsx.string)
                ->Option.getOr(Jsx.null)}
              </Mui.Box>
            </Mui.Box>}
          />
          <Icon.ArrowForwardIos />
        </Mui.ListItemButton>
      )
      ->Jsx.array}
    </Mui.List>
}
