module FormContent = ReactHookForm.Make({
  type t = Exercise_Type.t
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

  module TopPriority = FormContent.MakeInput({
    type t = bool
    let name = "topPriority"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  module SlowTempo = FormContent.MakeInput({
    type t = int
    let name = "slowTempo"
    let config = ReactHookForm.Rules.make({
      required: true,
      min: 0,
      max: 100,
    })
  })

  module FastTempo = FormContent.MakeInput({
    type t = int
    let name = "fastTempo"
    let config = ReactHookForm.Rules.make({
      required: true,
      min: 0,
      max: 100,
    })
  })
}

@react.component
let make = (
  ~isOpen as open_,
  ~onClose,
  ~onExerciseSubmited,
  ~exercise: option<Exercise_Type.t>=?,
) => {
  let fullScreen = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smDown)
  let intl = ReactIntl.useIntl()

  Console.log2("FKR: exercise add dialog render: exercise=%o", exercise)

  let defaultValues: Exercise_Type.t = {
    name: "",
    active: true,
    topPriority: false,
    slowTempo: 75,
    fastTempo: 100,
  }

  let form = FormContent.use(
    ~config={
      defaultValues: defaultValues,
    },
  )

  React.useEffect(() => {
    if (form->FormContent.formState).isSubmitSuccessful {
      form->FormContent.reset(defaultValues)
    }

    None
  }, (form->FormContent.formState, defaultValues))

  React.useEffect(() => {
    exercise->Option.forEach(({name, active, topPriority, slowTempo, fastTempo}) => {
      form->FormInput.Name.setValue(name)
      form->FormInput.Active.setValue(active)
      form->FormInput.TopPriority.setValue(topPriority)
      form->FormInput.SlowTempo.setValue(slowTempo)
      form->FormInput.FastTempo.setValue(fastTempo)
    })

    None
  }, [exercise])

  let onSubmit = exerciseFromForm => {
    onExerciseSubmited(exerciseFromForm, ~isNew=exercise->Option.isNone)
    onClose()
  }

  let onCancel = _ => onClose()

  Console.log2("FKR: exercise add dialog render: form=%o", form->FormContent.getValues)

  Console.log2("FKR: exercise add dialog render: exercise=%o", exercise)

  <Mui.Dialog open_ fullScreen onClose={(_, _) => onClose()}>
    {if fullScreen {
      <Mui.AppBar position={Relative}>
        <Mui.Toolbar>
          <Mui.IconButton onClick={_ => onClose()} color={Inherit}>
            <Icon.Close />
          </Mui.IconButton>
          <Mui.DialogTitle>
            {intl->ReactIntl.Intl.formatMessage(Message.Manage.createExerciseTitle)->Jsx.string}
          </Mui.DialogTitle>
        </Mui.Toolbar>
      </Mui.AppBar>
    } else {
      <Mui.DialogTitle>
        {intl->ReactIntl.Intl.formatMessage(Message.Manage.createExerciseTitle)->Jsx.string}
      </Mui.DialogTitle>
    }}
    <Mui.DialogContent>
      <Page alignContent={Stretch} justifyItems="stretch">
        <Form
          onSubmit={form->FormContent.handleSubmit((exercise, _event) => onSubmit(exercise))}
          onCancel>
          {form->FormInput.Name.renderWithRegister(
            <Mui.TextField
              required=true
              label={intl->ReactIntl.Intl.formatMessage(Message.Exercise.name)->Jsx.string}
              error={form->FormInput.Name.error->Option.isSome}
            />,
            ~config=FormInput.Active.makeRule({required: true}),
            (),
          )}
          {form->FormInput.Active.renderWithRegister(
            <Mui.FormControlLabel
              control={<Mui.Switch
                defaultChecked={exercise
                ->Option.map(({active}) => active)
                ->Option.getOr(defaultValues.active)}
              />}
              label={intl->ReactIntl.Intl.formatMessage(Message.Exercise.active)->Jsx.string}
            />,
            (),
          )}
          {form->FormInput.TopPriority.renderWithRegister(
            <Mui.FormControlLabel
              control={<Mui.Switch
                defaultChecked={exercise
                ->Option.map(({topPriority}) => topPriority)
                ->Option.getOr(defaultValues.topPriority)}
              />}
              label={intl
              ->ReactIntl.Intl.formatMessage(Message.Exercise.topPriority)
              ->Jsx.string}
            />,
            (),
          )}
          {form->FormInput.SlowTempo.renderWithRegister(
            <Mui.TextField
              required=true
              label={intl->ReactIntl.Intl.formatMessage(Message.Exercise.slowTempo)->Jsx.string}
              type_="number"
              error={form->FormInput.SlowTempo.error->Option.isSome}
              inputProps_={{
                endAdornment: <Mui.InputAdornment position={End}>
                  {Exercise_Util.unitOfTempo->Jsx.string}
                </Mui.InputAdornment>,
              }}
            />,
            ~config=FormInput.Active.makeRule({min: 0, max: 100}),
            (),
          )}
          {form->FormInput.FastTempo.renderWithRegister(
            <Mui.TextField
              required=true
              label={intl->ReactIntl.Intl.formatMessage(Message.Exercise.fastTempo)->Jsx.string}
              type_="number"
              error={form->FormInput.FastTempo.error->Option.isSome}
              inputProps_={{
                endAdornment: <Mui.InputAdornment position={End}>
                  {Exercise_Util.unitOfTempo->Jsx.string}
                </Mui.InputAdornment>,
              }}
            />,
            ~config=FormInput.Active.makeRule({min: 0, max: 100}),
            (),
          )}
        </Form>
      </Page>
    </Mui.DialogContent>
  </Mui.Dialog>
}
