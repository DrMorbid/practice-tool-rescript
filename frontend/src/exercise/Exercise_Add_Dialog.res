module Form = Exercise_Add_Dialog_Form

@react.component
let make = (
  ~isOpen as open_,
  ~onClose,
  ~onExerciseSubmited,
  ~exercise: option<Exercise_Type.t>=?,
) => {
  let smDown = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smDown)
  let intl = ReactIntl.useIntl()

  let form = Form.Content.use(
    ~config={
      defaultValues: Form.Input.defaultValues,
    },
  )

  React.useEffect(() => {
    if (form->Form.Content.formState).isSubmitSuccessful {
      form->Form.Content.reset(Form.Input.defaultValues)
    }

    None
  }, (form->Form.Content.formState, Form.Input.defaultValues))

  React.useEffect(() => {
    exercise->Option.forEach(({
      name,
      active,
      topPriority,
      ?slowTempo,
      ?fastTempo,
      ?lastPracticed,
    }) => {
      form->Form.Input.Name.setValue(name)
      form->Form.Input.Active.setValue(active)
      form->Form.Input.TopPriority.setValue(topPriority)
      slowTempo
      ->Option.map(slowTempo => slowTempo->Int.toString)
      ->Option.forEach(slowTempo => form->Form.Input.SlowTempo.setValue(slowTempo))
      form->Form.Input.TopPriority.setValue(topPriority)
      fastTempo
      ->Option.map(fastTempo => fastTempo->Int.toString)
      ->Option.forEach(fastTempo => form->Form.Input.FastTempo.setValue(fastTempo))
      lastPracticed->Option.forEach(
        lastPracticed => form->Form.Input.LastPracticed.setValue(Some(lastPracticed)),
      )
    })

    None
  }, [exercise])

  let onSubmit = (
    {name, active, topPriority, slowTempo, fastTempo, ?lastPracticed}: Exercise_Type.FromForm.t,
  ) => {
    onExerciseSubmited(
      (
        {
          name,
          active,
          topPriority,
          slowTempo: ?slowTempo->Int.fromString,
          fastTempo: ?fastTempo->Int.fromString,
          ?lastPracticed,
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
        <Common.Form
          header=Jsx.null
          gridTemplateRows="auto auto auto auto 1fr auto"
          onSubmit={form->Form.Content.handleSubmit((exercise, _event) => onSubmit(exercise))}
          onCancel>
          {form->Form.Input.renderName(~intl)}
          {form->Form.Input.renderActive(~exercise?, ~intl)}
          {form->Form.Input.renderTopPriority(~exercise?, ~intl)}
          {form->Form.Input.renderSlowTempo(~intl)}
          {form->Form.Input.renderFastTempo(~intl)}
        </Common.Form>
      </Page>
    </Mui.DialogContent>
  </Mui.Dialog>
}
