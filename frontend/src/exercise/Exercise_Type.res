@spice
type tempo = | @spice.as("SLOW") Slow | @spice.as("FAST") Fast

@spice
type lastPracticed = {
  date: @spice.codec(Util_Date.SpiceCodec.date) Date.t,
  tempo: tempo,
}

@spice
type t = {
  name: string,
  active: bool,
  topPriority: bool,
  slowTempo?: int,
  fastTempo?: int,
  lastPracticed?: lastPracticed,
}

module FromForm = {
  type t = {
    name: string,
    active: bool,
    topPriority: bool,
    slowTempo: string,
    fastTempo: string,
    lastPracticed?: lastPracticed,
  }
}

@spice
type toPractice = {
  name: string,
  tempo: tempo,
  tempoValue: int,
}

@spice
type practiced = {
  name: string,
  tempo: tempo,
}
