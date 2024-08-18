module Classes = Project_Add_Page_Classes
module Form = Project_Add_Page_Form

@react.component
let default = () => {
  let (actionButtonsHeight, setActionButtonsHeight) = React.useState(() => None)
  let (addExerciseDialogOpen, setAddExerciseDialogOpen) = React.useState(() => false)
  let (selectedExercise, setSelectedExrecise) = React.useState(() => None)
  let (selectedExerciseIndex, setSelectedExreciseIndex) = React.useState(() => None)
  let (listElementTopPosition, setListElementTopPosition) = React.useState(() => None)
  let (pageHeight, setPageHeight) = React.useState(() => None)
  let (saveError, setSaveError) = React.useState(() => None)
  let form = Form.Content.use(
    ~config={
      defaultValues: {name: "", active: true, exercises: []},
    },
  )
  let intl = ReactIntl.useIntl()
  let router = Next.Navigation.useRouter()
  let actionButtonsRef = React.useRef(Nullable.null)
  let listRef = React.useRef(Nullable.null)
  let pageRef = React.useRef(Nullable.null)
  let auth = ReactOidcContext.useAuth()
  let smDown = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smDown)
  let (bottomBarHeight, selectedProjectForManagement) = Store.useStoreWithSelector(({
    ?bottomBarHeight,
    ?selectedProjectForManagement,
  }) => (bottomBarHeight, selectedProjectForManagement))

  React.useEffect(() => {
    let actionButtonsElement =
      actionButtonsRef.current
      ->Nullable.toOption
      ->Option.map(current => current->ReactDOM.domElementToObj)

    setActionButtonsHeight(_ =>
      actionButtonsElement->Option.map(actionButtonsElement => actionButtonsElement["offsetHeight"])
    )

    None
  }, [actionButtonsRef])

  React.useEffect(() => {
    let listElement =
      listRef.current
      ->Nullable.toOption
      ->Option.map(current => current->ReactDOM.domElementToObj)

    setListElementTopPosition(_ => listElement->Option.map(listElement => listElement["offsetTop"]))

    None
  }, [listRef])

  React.useEffect(() => {
    let pageElement: option<Dom.element> = pageRef.current->Nullable.toOption

    setPageHeight(_ =>
      pageElement
      ->Option.map(
        pageElement => {
          let style = Webapi.Dom.window->Webapi.Dom.Window.getComputedStyle(pageElement)

          (
            (pageElement->ReactDOM.domElementToObj)["offsetHeight"],
            style
            ->Webapi.Dom.CssStyleDeclaration.paddingTop
            ->Float.parseFloat,
            style
            ->Webapi.Dom.CssStyleDeclaration.paddingBottom
            ->Float.parseFloat,
          )
        },
      )
      ->Option.map(
        ((pageHeight, paddingTop, paddingBottom)) => pageHeight -. paddingTop -. paddingBottom,
      )
    )

    None
  }, [pageRef])

  React.useEffect(() => {
    selectedProjectForManagement->Option.forEach(({name, active, exercises}) => {
      form->Form.Input.Name.setValue(name)
      form->Form.Input.Active.setValue(active)
      form->Form.Input.Exercises.setValue(exercises)
    })

    None
  }, [selectedProjectForManagement])

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
    form->Form.Input.Exercises.setValue(
      if isNew {
        form->Form.Input.Exercises.getValue->Array.concat([exercise])
      } else {
        form
        ->Form.Input.Exercises.getValue
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

  <Page
    alignContent={Stretch}
    spaceOnTop=true
    spaceOnBottom=true
    justifyItems="stretch"
    pageRef={pageRef}>
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
    <Common.Form
      header={<FormHeader message=Message.Manage.createProjectTitle />}
      gridTemplateRows="auto 1fr auto"
      onSubmit={form->Form.Content.handleSubmit((project, _event) => onSubmit(project))}
      onCancel
      fixedHeight=?pageHeight
      actionButtonsRef>
      <Mui.Box
        display={String("grid")}
        gridTemplateColumns={String("1fr")}
        gridTemplateRows={String("auto auto 1fr")}
        sx={Common.Form.Classes.formGaps->Array.concat(Classes.exercisesScrolling)->Mui.Sx.array}>
        {if smDown {
          [form->Form.Input.renderName(~intl), form->Form.Input.renderActive(~intl)]
        } else {
          [
            <Mui.Box
              display={String("grid")}
              gridAutoFlow={String("column")}
              gridAutoColumns={String("3fr 1fr")}
              gridAutoRows={String("1fr")}
              sx=Classes.nameAndActive>
              {form->Form.Input.renderName(~intl)}
              {form->Form.Input.renderActive(~intl)}
            </Mui.Box>,
          ]
        }->Jsx.array}
        {form->Form.Input.renderExercises(
          ~smDown,
          ~onExerciseClick,
          ~actionButtonsHeight?,
          ~bottomBarHeight?,
          ~listElementTopPosition?,
          ~listRef,
        )}
      </Mui.Box>
    </Common.Form>
    <AddButton
      onClick=onAddExercise
      bottomPosition={`${actionButtonsHeight->Option.map(Int.toString(_))->Option.getOr("0")}px`}
      bottomSpacing=5
    />
  </Page>
}
