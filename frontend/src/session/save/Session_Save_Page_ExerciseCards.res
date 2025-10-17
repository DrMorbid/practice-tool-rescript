module Classes = {
  let exercise = (tempo: Exercise.Type.tempo) =>
    Mui.Sx.array([
      Mui.Sx.Array.func((theme: Mui.Theme.t) =>
        [
          ("overflow", "visible"),
          (
            "background-color",
            switch (tempo, theme.palette.mode) {
            | (Slow, "light") => theme.palette.secondary.light
            | (Slow, "dark") => theme.palette.secondary.dark
            | (Fast, "light") => theme.palette.primary.light
            | (Fast, "dark") => theme.palette.primary.dark
            | _ => theme.palette.background.paper
            },
          ),
        ]
        ->Dict.fromArray
        ->MuiStyles.dictToSxArray
      ),
    ])
}

@react.component
let make = (~exercises: list<Exercise.Type.toPractice>) => {
  let isSmUp = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.smUp)

  let renderCardForXs = (name, tempoValue) =>
    <Mui.CardContent>
      <Mui.Grid
        display={String("grid")}
        gridAutoFlow={String("column")}
        justifyContent={String("space-evenly")}>
        <Mui.Typography> {name->Jsx.string} </Mui.Typography>
        <Mui.Typography> {`${tempoValue->Int.toString} %`->Jsx.string} </Mui.Typography>
      </Mui.Grid>
    </Mui.CardContent>

  let renderCardForSmUp = (name, tempoValue) =>
    <Mui.CardHeader
      title={name->Jsx.string} subheader={`${tempoValue->Int.toString} %`->Jsx.string}
    />

  <Mui.Grid
    display={String("grid")}
    gridTemplateColumns={String(isSmUp ? "1fr 1fr" : "1fr")}
    sx={App_Theme.Classes.itemGaps
    ->Array.concat(App_Theme.Classes.itemGapsHorizontal)
    ->Mui.Sx.array}>
    {exercises
    ->List.mapWithIndex(({name, tempoValue, tempo}, index) =>
      <Mui.Card sx={Classes.exercise(tempo)} key={`exercise-card-${index->Int.toString}`}>
        {isSmUp ? renderCardForSmUp(name, tempoValue) : renderCardForXs(name, tempoValue)}
      </Mui.Card>
    )
    ->List.toArray
    ->Jsx.array}
  </Mui.Grid>
}
