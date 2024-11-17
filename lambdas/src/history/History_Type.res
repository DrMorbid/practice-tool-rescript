@spice
type t = {
  userId: string,
  date: @spice.codec(Util.Date.SpiceCodec.date) Date.t,
  exercises: array<Exercise.Type.exerciseSession>,
}

@spice
type historyRequest = {dateFrom: @spice.codec(Util.Date.SpiceCodec.date) Date.t}
