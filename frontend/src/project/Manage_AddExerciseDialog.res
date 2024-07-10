module FormTest = {
  type rec input = {
    id: string,
    password: string,
    hobbies: array<hobby>,
  }
  and hobby = {value: string}

  module Form = ReactHookForm.Make({
    type t = input
  })

  module FormInput = {
    module Id = Form.MakeInput({
      type t = string
      let name = "id"
      let config = ReactHookForm.Rules.make({
        required: true,
      })
    })

    module Password = Form.MakeInput({
      type t = string
      let name = "password"
      let config = ReactHookForm.Rules.make({
        required: true,
      })
    })

    module Hobbies = Form.MakeInputArray({
      type t = hobby
      let name = "hobbies"
      let config = ReactHookForm.Rules.empty()
    })
  }
}

@react.component
let make = (~isOpen as open_, ~onClose) => {
  let fullScreen = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smDown)
  let intl = ReactIntl.useIntl()

  let form = FormTest.Form.use(
    ~config={
      defaultValues: {id: "id", password: "", hobbies: []},
    },
  )
  let hobbies = FormTest.FormInput.Hobbies.useFieldArray(form, ())

  let formState = form->FormTest.Form.formState
  let isValid = formState.isValid

  let handleClearPassword = _ => {
    form->FormTest.FormInput.Password.setValue("")
  }

  let handleAddHubby = _ => {
    hobbies->FormTest.FormInput.Hobbies.append({
      value: `요리`,
    })
  }

  React.useEffect0(() => {
    form->FormTest.FormInput.Id.focus
    None
  })

  <Mui.Dialog open_ fullScreen onClose={(_, _) => onClose()}>
    {if fullScreen {
      <Mui.AppBar position={Relative}>
        <Mui.Toolbar>
          <Mui.IconButton onClick={_ => onClose()} color={Inherit}>
            <Icon.CloseTwoTone />
          </Mui.IconButton>
          <Mui.DialogTitle>
            {intl->ReactIntl.Intl.formatMessage(Message.Manage.createProjectTitle)->Jsx.string}
          </Mui.DialogTitle>
        </Mui.Toolbar>
      </Mui.AppBar>
    } else {
      <Mui.DialogTitle>
        {intl->ReactIntl.Intl.formatMessage(Message.Manage.createProjectTitle)->Jsx.string}
      </Mui.DialogTitle>
    }}
    <Mui.DialogContent>
      <form
        onSubmit={form->FormTest.Form.handleSubmit((input, _) =>
          Js.log((input.id, input.password, input.hobbies))
        )}>
        <label>
          {form->FormTest.FormInput.Id.renderWithRegister(
            <input placeholder="id" type_="text" />,
            (),
          )}
        </label>
        {form
        ->FormTest.FormInput.Id.error
        ->Belt.Option.mapWithDefault(React.null, error => {
          <p> {error.message->React.string} </p>
        })}
        <label>
          {form->FormTest.FormInput.Password.renderWithRegister(
            <input placeholder="password" type_="password" />,
            (),
          )}
        </label>
        {form
        ->FormTest.FormInput.Password.error
        ->Belt.Option.mapWithDefault(React.null, error => {
          <p> {error.message->React.string} </p>
        })}
        {hobbies
        ->FormTest.FormInput.Hobbies.fields
        ->Belt.Array.mapWithIndex((index, field) => {
          <div key={field->FormTest.FormInput.Hobbies.id}>
            {form->FormTest.FormInput.Hobbies.renderWithIndexRegister(
              index,
              <input type_="text" />,
              ~property="value",
              (),
            )}
            <p> {`Current value: ${field.value}`->React.string} </p>
          </div>
        })
        ->React.array}
        <button type_="button" onClick={handleAddHubby}> {`Add new hubby`->React.string} </button>
        <button type_="button" onClick={handleClearPassword}>
          {`Clear password`->React.string}
        </button>
        <button disabled={!isValid} type_="submit"> {`Ok`->React.string} </button>
      </form>
    </Mui.DialogContent>
  </Mui.Dialog>
}
