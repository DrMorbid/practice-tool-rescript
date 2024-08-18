module Content = ReactHookForm.Make({
  type t = Exercise_Type.FromForm.t
})

module Input = {
  let defaultValues: Exercise_Type.FromForm.t = {
    name: "",
    active: true,
    topPriority: false,
    slowTempo: "75",
    fastTempo: "100",
  }

  module Name = Content.MakeInput({
    type t = string
    let name = "name"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  let renderName = (~intl, form) =>
    form->Name.renderWithRegister(
      <Mui.TextField
        variant={Standard}
        required=true
        label={intl->ReactIntl.Intl.formatMessage(Message.Exercise.name)->Jsx.string}
        error={form->Name.error->Option.isSome}
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

  module TopPriority = Content.MakeInput({
    type t = bool
    let name = "topPriority"
    let config = ReactHookForm.Rules.make({
      required: true,
    })
  })

  let renderTopPriority = (~exercise: option<Exercise_Type.t>=?, ~intl, form) =>
    form->TopPriority.renderWithRegister(
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
    )

  module SlowTempo = Content.MakeInput({
    type t = string
    let name = "slowTempo"
    let config = ReactHookForm.Rules.make({
      required: true,
      min: 0,
      max: 100,
    })
  })

  let renderSlowTempo = (~intl, form) =>
    form->SlowTempo.renderWithRegister(
      <Mui.TextField
        variant={Standard}
        required=true
        label={intl->ReactIntl.Intl.formatMessage(Message.Exercise.slowTempo)->Jsx.string}
        type_="number"
        error={form->SlowTempo.error->Option.isSome}
        inputProps_={{
          endAdornment: <Mui.InputAdornment position={End}>
            {Exercise_Util.unitOfTempo->Jsx.string}
          </Mui.InputAdornment>,
        }}
      />,
      ~config=SlowTempo.makeRule({min: 0, max: 100}),
      (),
    )

  module FastTempo = Content.MakeInput({
    type t = string
    let name = "fastTempo"
    let config = ReactHookForm.Rules.make({
      required: true,
      min: 0,
      max: 100,
    })
  })

  let renderFastTempo = (~intl, form) =>
    form->FastTempo.renderWithRegister(
      <Mui.TextField
        variant={Standard}
        required=true
        label={intl->ReactIntl.Intl.formatMessage(Message.Exercise.fastTempo)->Jsx.string}
        type_="number"
        error={form->FastTempo.error->Option.isSome}
        inputProps_={{
          endAdornment: <Mui.InputAdornment position={End}>
            {Exercise_Util.unitOfTempo->Jsx.string}
          </Mui.InputAdornment>,
        }}
      />,
      ~config=FastTempo.makeRule({min: 0, max: 100}),
      (),
    )
}
