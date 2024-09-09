module Form = Session_Page_Form

let selectFirstProjectName = (~form, projects) =>
  projects->Util.Fetch.Response.forSuccess(projects =>
    projects
    ->Array.get(0)
    ->Option.forEach(({name}: Project.Type.t) => form->Form.Input.ProjectName.setValue(name))
  )

@react.component
let default = () => {
  let (projects, setProjects) = React.useState(() => Util.Fetch.Response.NotStarted)
  let form = Form.Content.use(
    ~config={
      defaultValues: Form.Input.defaultValues,
    },
  )
  let auth = ReactOidcContext.useAuth()
  let intl = ReactIntl.useIntl()

  React.useEffect(() => {
    setProjects(_ => Pending)

    Util.Fetch.fetch(Project, ~method=Get, ~auth, ~responseDecoder=Project_Type.projects_decode)
    ->Promise.thenResolve(result =>
      switch result {
      | Ok(projects) => setProjects(_ => Ok(projects))
      | Error(error) => setProjects(_ => Error(error))
      }
    )
    ->ignore

    None
  }, [])

  React.useEffect(() => {
    projects->selectFirstProjectName(~form)

    None
  }, [projects])

  let onSubmit = projectName => Console.log2("FKR: selected project name is %o", projectName)

  let onCancel = _ => projects->selectFirstProjectName(~form)

  switch projects {
  | NotStarted => Jsx.null
  | Pending => <Mui.Skeleton variant={Rectangular} height={Number(48.)} />
  | Ok(projects) =>
    <Page alignContent={Stretch} spaceOnTop=true spaceOnBottom=true justifyItems="stretch">
      <Common.Form
        header={<FormHeader message=Message.Session.selectProjectTitle />}
        gridTemplateRows="auto 1fr auto"
        onSubmit={form->Form.Content.handleSubmit((projectName, _event) => onSubmit(projectName))}
        onCancel
        submitPending=false>
        <Mui.Box
          display={String("grid")}
          gridTemplateColumns={String("1fr")}
          gridTemplateRows={String("1fr")}
          sx={Common.Form.Classes.formGaps->Mui.Sx.array}>
          {form->Form.Input.renderProjectName(
            ~intl,
            ~projectNames={projects->Array.map(({name}) => name)},
          )}
        </Mui.Box>
      </Common.Form>
    </Page>
  | Error({message}) =>
    <Snackbar
      isOpen={projects->Util.Fetch.Response.isError}
      severity={Error}
      title={Message(Message.Manage.couldNotLoadProject)}
      body={String(message)}
    />
  }
}
