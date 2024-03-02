@spice
type tempo = | @spice.as("SLOW") Slow | @spice.as("FAST") Fast

@spice
type lastPracticed = {
  date?: @spice.codec(Utils.Date.SpiceCodec.date) Date.t,
  tempo?: tempo,
}

@spice
type t = {
  name?: string,
  active?: bool,
  topPriority?: bool,
  slowTempo?: string,
  fastTempo?: string,
  lastPracticed?: lastPracticed,
}

module Database = {
  type lastPracticed = {
    date: string,
    tempo: string,
  }

  type t = {
    name: string,
    active: bool,
    topPriority: bool,
    slowTempo: string,
    fastTempo: string,
    lastPracticed?: lastPracticed,
  }
}
