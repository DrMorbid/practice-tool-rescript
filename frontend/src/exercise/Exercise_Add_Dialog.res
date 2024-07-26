module FormContent = ReactHookForm.Make({
  type t = Exercise_Type.FromForm.t
})

module FormInput = {
  let defaultValues: Exercise_Type.FromForm.t = {
    name: "",
    active: true,
    topPriority: false,
    slowTempo: "75",
    fastTempo: "100",
  }

  module Name = FormContent.MakeInput({
    type t = string
    let name = "name"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  let renderName = (~intl, form) =>
    form->Name.renderWithRegister(
      <Mui.TextField
        required=true
        label={intl->ReactIntl.Intl.formatMessage(Message.Exercise.name)->Jsx.string}
        error={form->Name.error->Option.isSome}
      />,
      ~config=Name.makeRule({required: true}),
      (),
    )

  module Active = FormContent.MakeInput({
    type t = bool
    let name = "active"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  let renderActive = (~exercise: option<Exercise_Type.t>=?, ~intl, form) =>
    form->Active.renderWithRegister(
      <Mui.FormControlLabel
        control={<Mui.Switch
          defaultChecked={exercise
          ->Option.map(({active}) => active)
          ->Option.getOr(defaultValues.active)}
        />}
        label={intl->ReactIntl.Intl.formatMessage(Message.Exercise.active)->Jsx.string}
      />,
      (),
    )

  module TopPriority = FormContent.MakeInput({
    type t = bool
    let name = "topPriority"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  module SlowTempo = FormContent.MakeInput({
    type t = string
    let name = "slowTempo"
    let config = ReactHookForm.Rules.make({
      required: true,
      min: 0,
      max: 100,
    })
  })

  module FastTempo = FormContent.MakeInput({
    type t = string
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
  let smDown = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smDown)
  let intl = ReactIntl.useIntl()

  let form = FormContent.use(
    ~config={
      defaultValues: FormInput.defaultValues,
    },
  )

  React.useEffect(() => {
    if (form->FormContent.formState).isSubmitSuccessful {
      form->FormContent.reset(FormInput.defaultValues)
    }

    None
  }, (form->FormContent.formState, FormInput.defaultValues))

  React.useEffect(() => {
    exercise->Option.forEach(({name, active, topPriority, ?slowTempo, ?fastTempo}) => {
      form->FormInput.Name.setValue(name)
      form->FormInput.Active.setValue(active)
      form->FormInput.TopPriority.setValue(topPriority)
      slowTempo
      ->Option.map(slowTempo => slowTempo->Int.toString)
      ->Option.forEach(slowTempo => form->FormInput.SlowTempo.setValue(slowTempo))
      form->FormInput.TopPriority.setValue(topPriority)
      fastTempo
      ->Option.map(fastTempo => fastTempo->Int.toString)
      ->Option.forEach(fastTempo => form->FormInput.FastTempo.setValue(fastTempo))
    })

    None
  }, [exercise])

  let onSubmit = ({name, active, topPriority, slowTempo, fastTempo}: Exercise_Type.FromForm.t) => {
    onExerciseSubmited(
      (
        {
          name,
          active,
          topPriority,
          slowTempo: ?slowTempo->Int.fromString,
          fastTempo: ?fastTempo->Int.fromString,
        }: Exercise_Type.t
      ),
      ~isNew=exercise->Option.isNone,
    )
    onClose()
  }

  let onCancel = _ => onClose()

  <Mui.Dialog open_ fullScreen=smDown onClose={(_, _) => onClose()}>
    {if smDown {
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
      <Page alignContent={Stretch} justifyItems=?{smDown ? Some("stretch") : None}>
        <Form
          onSubmit={form->FormContent.handleSubmit((exercise, _event) => onSubmit(exercise))}
          onCancel>
          {form->FormInput.renderName(~intl)}
          {form->FormInput.renderActive(~exercise?, ~intl)}
          {form->FormInput.TopPriority.renderWithRegister(
            <Mui.FormControlLabel
              control={<Mui.Switch
                defaultChecked={exercise
                ->Option.map(({topPriority}) => topPriority)
                ->Option.getOr(FormInput.defaultValues.topPriority)}
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
