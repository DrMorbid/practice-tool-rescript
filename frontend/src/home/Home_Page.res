@react.component
let default = () => {
  <Mui.Grid>
    <Mui.Typography variant={H1}> {"Welcome to Practice Tool"->Jsx.string} </Mui.Typography>
    <Mui.Button variant={Contained}> {"Sign in"->Jsx.string} </Mui.Button>
  </Mui.Grid>
}
