@spice
type tempo = | @spice.as("SLOW") Slow | @spice.as("FAST") Fast

@spice
type lastPracticed = {
  date: @spice.codec(Util.Date.SpiceCodec.date) Date.t,
  tempo: tempo,
}

@spice
type t = {
  name: string,
  active: bool,
  topPriority: bool,
  slowTempo: int,
  fastTempo: int,
  lastPracticed?: lastPracticed,
}
