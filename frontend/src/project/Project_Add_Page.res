module FormContent = ReactHookForm.Make({
  type t = Project_Type.t
})

module FormInput = {
  module Name = FormContent.MakeInput({
    type t = string
    let name = "name"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  module Active = FormContent.MakeInput({
    type t = bool
    let name = "active"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  module Exercises = FormContent.MakeInputArray({
    type t = Exercise.Type.t
    let name = "exercises"
    let config = ReactHookForm.Rules.empty()
  })
}

@react.component
let default = () => {
  let (actionButtonsHeight, setActionButtonsHeight) = React.useState(() => 0)
  let (addExerciseDialogOpen, setAddExerciseDialogOpen) = React.useState(() => false)
  let form = FormContent.use(
    ~config={
      defaultValues: {name: "", active: true, exercises: []},
    },
  )
  let intl = ReactIntl.useIntl()
  let router = Next.Navigation.useRouter()
  let actionButtonsRef = React.useRef(Nullable.null)

  React.useEffect(() => {
    let actionButtonsElement =
      actionButtonsRef.current
      ->Nullable.toOption
      ->Option.map(current => current->ReactDOM.domElementToObj)
      ->Option.getOr(Object.make())

    Console.log(actionButtonsElement["getBoundingClientRect()"])

    setActionButtonsHeight(_ => actionButtonsElement["offsetHeight"])

    None
  }, [actionButtonsRef])

  let onSubmit = project => Console.log2("FKR: project submit: project=%o", project)

  let onCancel = _ => router->Route.FrontEnd.push(~route=#"/manage")

  let onAddExercise = _ => setAddExerciseDialogOpen(_ => true)

  let onAddExerciseDialogClosed = _ => setAddExerciseDialogOpen(_ => false)

  let onExerciseAdded = exercise =>
    form->FormInput.Exercises.setValue(form->FormInput.Exercises.getValue->Array.concat([exercise]))

  Console.log2("FKR: project add page render: exercises=%o", form->FormInput.Exercises.getValue)

  <Page alignContent={Stretch} spaceOnTop=true spaceOnBottom=true justifyItems="stretch">
    <Exercise.Add.Dialog
      isOpen=addExerciseDialogOpen onClose=onAddExerciseDialogClosed onExerciseAdded
    />
    <Form
      onSubmit={form->FormContent.handleSubmit((project, _event) => onSubmit(project))}
      onCancel
      actionButtonsRef>
      <FormHeader message=Message.Manage.createProjectTitle />
      {form->FormInput.Name.renderWithRegister(
        <Mui.TextField
          required=true
          label={intl->ReactIntl.Intl.formatMessage(Message.Project.name)->Jsx.string}
          error={form->FormInput.Name.error->Option.isSome}
        />,
        ~config=FormInput.Active.makeRule({required: true}),
        (),
      )}
      {form->FormInput.Active.renderWithRegister(
        <Mui.FormControlLabel
          control={<Mui.Switch defaultChecked=true />}
          label={intl->ReactIntl.Intl.formatMessage(Message.Project.active)->Jsx.string}
        />,
        (),
      )}
      <Mui.List>
        {form
        ->FormInput.Exercises.getValue
        ->Array.mapWithIndex(({name, slowTempo, fastTempo}, index) =>
          <Mui.ListItemButton key={`exercise-${index->Int.toString}`}>
            <Mui.ListItemText
              primary={name->Jsx.string}
              secondary={<Mui.Box
                display={String("grid")}
                gridAutoFlow={String("column")}
                gridAutoColumns={String("1fr")}
                gridAutoRows={String("1fr")}>
                <Mui.Box> {`${slowTempo->Util.Exercise.formatTempo}`->Jsx.string} </Mui.Box>
                <Mui.Box> {`${fastTempo->Util.Exercise.formatTempo}`->Jsx.string} </Mui.Box>
              </Mui.Box>}
            />
            <Icon.ArrowForwardIosTwoTone />
          </Mui.ListItemButton>
        )
        ->Jsx.array}
      </Mui.List>
    </Form>
    <AddButton
      onClick=onAddExercise
      bottomPosition={`${actionButtonsHeight->Int.toString}px`}
      bottomSpacing=5
    />
  </Page>
}
