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
  let form = ReactDOM.Style.make(~gridRowGap="16px", ())->MuiStyles.styleToSx
}

@react.component
let default = () => {
  let (actionButtonsHeight, setActionButtonsHeight) = React.useState(() => 0)

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

  let onAddExercise = _ => ()

  <Page alignContent={Stretch} spaceOnTop=true spaceOnBottom=true justifyItems="stretch">
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
