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

  module TopProirity = Form.MakeInput({
    type t = bool
    let name = "topProirity"
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

@react.component
let make = (~isOpen as open_, ~onClose) => {
  let fullScreen = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smDown)
  let intl = ReactIntl.useIntl()

  let _form = Form.use(
    ~config={
      defaultValues: {name: "", active: true, topPriority: false, slowTempo: 75, fastTempo: 100},
    },
  )

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
    <Mui.DialogContent />
  </Mui.Dialog>
}
