type t
type utc

type unitOfTime = [
  | #year
  | #quarter
  | #month
  | #week
  | #isoWeek
  | #date
  | #day
  | #hour
  | #minute
  | #second
]

@module("dayjs") external dayjs: t = "default"
@module("dayjs") external dayjsFromDate: Date.t => t = "default"

@send external utc: t => t = "utc"
@send external format: t => string = "format"
@send external formatWithPattern: (t, string) => string = "format"
@send external extend: (t, utc) => unit = "extend"
@send external toDate: t => Date.t = "toDate"
@send external startOf: (t, unitOfTime) => t = "startOf"

@module("dayjs/plugin/utc") external utcPlugin: utc = "default"
