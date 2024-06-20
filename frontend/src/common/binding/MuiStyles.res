type options = {
  breakpoints?: array<[#xs | #sm | #md | #lg | #xl]>,
  disableAlign?: bool,
  factor?: int,
  variants?: array<Mui.Typography.variant>,
}

@module("@mui/material/styles")
external responsiveFontSizes: (Mui.Theme.t, ~options: options=?) => Mui.Theme.t =
  "responsiveFontSizes"

external styleToSx: ReactDOM.Style.t => Mui.Sx.props = "%identity"
external sxToStyle: Mui.Sx.props => ReactDOM.Style.t = "%identity"
external styleToSxArray: ReactDOM.Style.t => Mui.Sx.Array.t = "%identity"
