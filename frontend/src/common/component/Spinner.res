module Classes = {
  let container = App_Theme.Classes.maxHeight->Mui.Sx.array
}

@react.component
let make = () => {
  <Mui.Box
    display={String("grid")}
    justifyContent={String("center")}
    alignContent={String("center")}
    sx=Classes.container>
    <Mui.CircularProgress />
  </Mui.Box>
}
