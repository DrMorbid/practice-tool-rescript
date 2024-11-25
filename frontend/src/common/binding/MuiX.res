type dateAdapter

@module("@mui/x-date-pickers/AdapterDayjs") external adapterDayjs: dateAdapter = "AdapterDayjs"

module LocalizationProvider = {
  @module("@mui/x-date-pickers/LocalizationProvider") @react.component
  external make: (~dateAdapter: dateAdapter, ~children: Jsx.element) => Jsx.element =
    "LocalizationProvider"
}

module DatePicker = {
  @module("@mui/x-date-pickers/DatePicker") @react.component
  external make: (
    ~label: string,
    ~value: Dayjs.t,
    ~onChange: Dayjs.t => unit,
    ~maxDate: Dayjs.t=?,
  ) => Jsx.element = "DatePicker"
}
