module Classes = {
  let container = Mui.Sx.array(
    [ReactDOM.Style.make(~justifyItems="center", ())->MuiStyles.styleToSxArray]->Array.concat(
      App_Theme.Classes.maxHeight,
    ),
  )
}

@react.component
let default = () => {
  <Mui.Box
    display={String("grid")}
    gridAutoRows={String("min-content")}
    alignContent={String("space-evenly")}
    sx=Classes.container>
    <Mui.Typography variant={H1} textAlign={Center}>
      {"Welcome to Practice Tool"->Jsx.string}
    </Mui.Typography>
    <Mui.Button variant={Contained} size={Large}> {"Sign in"->Jsx.string} </Mui.Button>
  </Mui.Box>
}
