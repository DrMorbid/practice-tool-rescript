let maxHeight = [
  Mui.Sx.Array.obj({
    height: String("100%"),
  }),
]
let maxWidth = [Mui.Sx.Array.obj({width: String("100%")})]
let itemGapsSm = [
  Mui.Sx.Array.func(theme =>
    [("grid-row-gap", theme->MuiSpacingFix.spacing(1))]->Dict.fromArray->MuiStyles.dictToSxArray
  ),
]
let itemGaps = [
  Mui.Sx.Array.func(theme =>
    [("grid-row-gap", theme->MuiSpacingFix.spacing(2))]->Dict.fromArray->MuiStyles.dictToSxArray
  ),
]
let itemGapsLg = [
  Mui.Sx.Array.func(theme =>
    [("grid-row-gap", theme->MuiSpacingFix.spacing(8))]->Dict.fromArray->MuiStyles.dictToSxArray
  ),
]
let itemGapsHorizontal = [
  Mui.Sx.Array.func(theme =>
    [("grid-column-gap", theme->MuiSpacingFix.spacing(2))]->Dict.fromArray->MuiStyles.dictToSxArray
  ),
]
let scrollable = [("overflow", "auto")]->Dict.fromArray->MuiStyles.dictToSxArray
