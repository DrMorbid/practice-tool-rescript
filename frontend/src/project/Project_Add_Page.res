module Form = ReactHookForm.Make({
  type t = Project_Type.t
})

module FormInput = {
  module Name = Form.MakeInput({
    type t = string
    let name = "name"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  module Active = Form.MakeInput({
    type t = bool
    let name = "active"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  module Exercises = Form.MakeInputArray({
    type t = Exercise.Type.t
    let name = "exercises"
    let config = ReactHookForm.Rules.empty()
  })
}

module Classes = {
  let form = Mui.Sx.array([
    Mui.Sx.Array.func(theme =>
      ReactDOM.Style.make(~gridRowGap=theme->MuiSpacingFix.spacing(2), ())->MuiStyles.styleToSxArray
    ),
  ])
}

@react.component
let default = () => {
  let (actionButtonsHeight, setActionButtonsHeight) = React.useState(() => 0)
  let (addExerciseDialogOpen, setAddExerciseDialogOpen) = React.useState(() => false)
  let form = Form.use(
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

  let onSubmit =
    form->Form.handleSubmit((project, _event) =>
      Console.log2("FKR: project submit: project=%o", project)
    )

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
    <form onSubmit>
      <Mui.Box
        display={String("grid")}
        alignContent={String("space-between")}
        sx={App_Theme.Classes.maxHeight->Mui.Sx.array}>
        <Mui.Box display={String("grid")} sx=Classes.form>
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
        </Mui.Box>
        <Mui.Box
          display={String("grid")}
          gridAutoFlow={String("column")}
          gridAutoColumns={String("1fr")}
          gridAutoRows={String("1fr")}
          ref={actionButtonsRef->ReactDOM.Ref.domRef}>
          <Mui.Button onClick=onCancel variant={Outlined}>
            {intl->ReactIntl.Intl.formatMessage(Message.Button.cancel)->Jsx.string}
          </Mui.Button>
          <Mui.Button type_=Submit variant={Contained}>
            {intl->ReactIntl.Intl.formatMessage(Message.Button.save)->Jsx.string}
          </Mui.Button>
        </Mui.Box>
      </Mui.Box>
    </form>
    <AddButton
      onClick=onAddExercise
      bottomPosition={`${actionButtonsHeight->Int.toString}px`}
      bottomSpacing=5
    />
  </Page>
}
