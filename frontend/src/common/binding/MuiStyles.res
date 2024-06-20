type options = {
  breakpoints?: array<[#xs | #sm | #md | #lg | #xl]>,
  disableAlign?: bool,
  factor?: int,
  variants?: array<Mui.Typography.variant>,
}

@module("@mui/material/styles")
external responsiveFontSizes: (Mui.Theme.t, ~options: options=?) => Mui.Theme.t =
  "responsiveFontSizes"
