module Classes = {
  let layout = ReactDOM.Style.make(~justifyItems="center", ())
}

@react.component
let default = () => {
  <Mui.Box
    display={String("grid")}
    gap={Number(4.)}
    marginTop={Number(3.)}
    sx={Classes.layout->MuiStyles.styleToSx}>
    <Mui.Typography variant={H1} textAlign={Center}>
      {"Welcome to Practice Tool"->Jsx.string}
    </Mui.Typography>
    <Mui.Button variant={Contained}> {"Sign in"->Jsx.string} </Mui.Button>
  </Mui.Box>
}
