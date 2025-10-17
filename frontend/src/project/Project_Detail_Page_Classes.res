let nameAndActive = Mui.Sx.array([
  Mui.Sx.Array.func(theme =>
    [("grid-column-gap", theme->MuiSpacingFix.spacing(2))]->Dict.fromArray->MuiStyles.dictToSxArray
  ),
])
