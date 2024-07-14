module Form = ReactHookForm.Make({
  type t = Exercise_Type.t
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

  module TopPriority = Form.MakeInput({
    type t = bool
    let name = "topPriority"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  module SlowTempo = Form.MakeInput({
    type t = int
    let name = "slowTempo"
    let config = ReactHookForm.Rules.make({
      required: true,
      min: 0,
      max: 100,
    })
  })

  module FastTempo = Form.MakeInput({
    type t = int
    let name = "fastTempo"
    let config = ReactHookForm.Rules.make({
      required: true,
      min: 0,
      max: 100,
    })
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
let make = (~isOpen as open_, ~onClose, ~onExerciseAdded) => {
  let fullScreen = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smDown)
  let intl = ReactIntl.useIntl()

  let defaultValues: Exercise_Type.t = {
    name: "",
    active: true,
    topPriority: false,
    slowTempo: 75,
    fastTempo: 100,
  }
  let form = Form.use(
    ~config={
      defaultValues: defaultValues,
    },
  )

  React.useEffect(() => {
    if (form->Form.formState).isSubmitSuccessful {
      form->Form.reset(defaultValues)
    }

    None
  }, [form->Form.formState])

  let onSubmit = exercise => {
    onExerciseAdded(exercise)
    onClose()
  }

  let onCancel = _ => onClose()

  Console.log2("FKR: exercise add dialog render: form=%o", form->Form.getValues)

  <Mui.Dialog open_ fullScreen onClose={(_, _) => onClose()}>
    {if fullScreen {
      <Mui.AppBar position={Relative}>
        <Mui.Toolbar>
          <Mui.IconButton onClick={_ => onClose()} color={Inherit}>
            <Icon.CloseTwoTone />
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
        <form onSubmit={form->Form.handleSubmit((exercise, _event) => onSubmit(exercise))}>
          <Mui.Box
            display={String("grid")}
            alignContent={String("space-between")}
            sx={App_Theme.Classes.maxHeight->Mui.Sx.array}>
            <Mui.Box display={String("grid")} sx={Classes.form}>
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
                  control={<Mui.Switch defaultChecked=defaultValues.active />}
                  label={intl->ReactIntl.Intl.formatMessage(Message.Exercise.active)->Jsx.string}
                />,
                (),
              )}
              {form->FormInput.TopPriority.renderWithRegister(
                <Mui.FormControlLabel
                  control={<Mui.Switch defaultChecked=defaultValues.topPriority />}
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
                      {"%"->Jsx.string}
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
                      {"%"->Jsx.string}
                    </Mui.InputAdornment>,
                  }}
                />,
                ~config=FormInput.Active.makeRule({min: 0, max: 100}),
                (),
              )}
            </Mui.Box>
            <Mui.Box
              display={String("grid")}
              gridAutoFlow={String("column")}
              gridAutoColumns={String("1fr")}
              gridAutoRows={String("1fr")}>
              <Mui.Button onClick=onCancel variant={Outlined}>
                {intl->ReactIntl.Intl.formatMessage(Message.Button.cancel)->Jsx.string}
              </Mui.Button>
              <Mui.Button type_=Submit variant={Contained}>
                {intl->ReactIntl.Intl.formatMessage(Message.Button.save)->Jsx.string}
              </Mui.Button>
            </Mui.Box>
          </Mui.Box>
        </form>
      </Page>
    </Mui.DialogContent>
  </Mui.Dialog>
}
