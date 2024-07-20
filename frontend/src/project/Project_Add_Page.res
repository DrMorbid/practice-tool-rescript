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

module Classes = {
  let list = (~listElementTopPosition, ~bottomBarHeight, ~actionButtonsHeight) =>
    Mui.Sx.array([
      Mui.Sx.Array.func(theme =>
        ReactDOM.Style.make(
          ~overflow="auto",
          ~height=`calc(100vh - ${listElementTopPosition->Int.toString}px - ${bottomBarHeight->Int.toString}px - ${actionButtonsHeight->Int.toString}px - ${theme->MuiSpacingFix.spacing(
              5,
            )})`,
          (),
        )->MuiStyles.styleToSxArray
      ),
    ])
}

@react.component
let default = () => {
  let (actionButtonsHeight, setActionButtonsHeight) = React.useState(() => 0)
  let (addExerciseDialogOpen, setAddExerciseDialogOpen) = React.useState(() => false)
  let (selectedExercise, setSelectedExrecise) = React.useState(() => None)
  let (selectedExerciseIndex, setSelectedExreciseIndex) = React.useState(() => None)
  let (listElementTopPosition, setListElementTopPosition) = React.useState(() => 0)
  let (saveError, setSaveError) = React.useState(() => None)
  let form = FormContent.use(
    ~config={
      defaultValues: {name: "", active: true, exercises: []},
    },
  )
  let intl = ReactIntl.useIntl()
  let router = Next.Navigation.useRouter()
  let actionButtonsRef = React.useRef(Nullable.null)
  let listRef = React.useRef(Nullable.null)
  let bottomBarHeight = Store.useStoreWithSelector(({bottomBarHeight}) => bottomBarHeight)
  let auth = ReactOidcContext.useAuth()

  React.useEffect(() => {
    let actionButtonsElement =
      actionButtonsRef.current
      ->Nullable.toOption
      ->Option.map(current => current->ReactDOM.domElementToObj)
      ->Option.getOr(Object.make())

    setActionButtonsHeight(_ => actionButtonsElement["offsetHeight"])

    None
  }, [actionButtonsRef])

  React.useEffect(() => {
    let listElement =
      listRef.current
      ->Nullable.toOption
      ->Option.map(current => current->ReactDOM.domElementToObj)
      ->Option.getOr(Object.make())

    setListElementTopPosition(_ => listElement["offsetTop"])

    None
  }, [listRef])

  let onSubmit = project => {
    Util.Fetch.fetch(
      #"/project",
      ~method=Post,
      ~auth,
      ~responseDecoder=Spice.stringFromJson,
      ~body=project->Project_Type.t_encode,
    )
    ->Promise.thenResolve(result =>
      switch result {
      | Ok(_) => router->Route.FrontEnd.push(~route=#"/manage")
      | Error(error) => setSaveError(_ => Some(error))
      }
    )
    ->ignore
  }

  let onCancel = _ => router->Route.FrontEnd.push(~route=#"/manage")

  let onAddExercise = _ => {
    setSelectedExrecise(_ => None)
    setSelectedExreciseIndex(_ => None)
    setAddExerciseDialogOpen(_ => true)
  }

  let onAddExerciseDialogClosed = _ => setAddExerciseDialogOpen(_ => false)

  let onExerciseSubmited = (exercise, ~isNew) =>
    form->FormInput.Exercises.setValue(
      if isNew {
        form->FormInput.Exercises.getValue->Array.concat([exercise])
      } else {
        form
        ->FormInput.Exercises.getValue
        ->Array.toSorted(Exercise.Util.getOrdering)
        ->Array.mapWithIndex((existingExercise, index) =>
          if (
            selectedExerciseIndex->Option.equal(Some(index), (index1, index2) => index1 == index2)
          ) {
            exercise
          } else {
            existingExercise
          }
        )
      },
    )

  let onExerciseClick = (~index, exercise) => {
    setSelectedExrecise(_ => Some(exercise))
    setSelectedExreciseIndex(_ => Some(index))
    setAddExerciseDialogOpen(_ => true)
  }

  <Page alignContent={Stretch} spaceOnTop=true spaceOnBottom=true justifyItems="stretch">
    <Exercise.Add.Dialog
      isOpen=addExerciseDialogOpen
      onClose=onAddExerciseDialogClosed
      onExerciseSubmited
      exercise=?selectedExercise
    />
    {saveError
    ->Option.map(({message}) =>
      <Snackbar
        isOpen={saveError->Option.isSome}
        severity={Error}
        title={Message(Message.Project.couldNotSaveProject)}
        body={String(message)}
      />
    )
    ->Option.getOr(Jsx.null)}
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
      <Mui.List
        sx={Classes.list(~listElementTopPosition, ~bottomBarHeight, ~actionButtonsHeight)}
        ref={listRef->ReactDOM.Ref.domRef}>
        {form
        ->FormInput.Exercises.getValue
        ->Array.toSorted(Exercise.Util.getOrdering)
        ->Array.mapWithIndex((exercise, index) =>
          <Mui.ListItemButton
            key={`exercise-${index->Int.toString}`}
            divider=true
            onClick={_ => onExerciseClick(exercise, ~index)}>
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
    </Form>
    <AddButton
      onClick=onAddExercise
      bottomPosition={`${actionButtonsHeight->Int.toString}px`}
      bottomSpacing=5
    />
  </Page>
}
