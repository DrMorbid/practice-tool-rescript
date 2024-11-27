type t
type utc

@module("dayjs") external dayjs: t = "default"
@module("dayjs") external dayjsFromDate: Date.t => t = "default"

@send external utc: t => t = "utc"
@send external format: t => string = "format"
@send external formatWithPattern: (t, string) => string = "format"
@send external extend: (t, utc) => unit = "extend"
@send external toDate: t => Date.t = "toDate"

@module("dayjs/plugin/utc") external utcPlugin: utc = "default"
