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

@spice
type toPractice = {
  name: string,
  tempo: tempo,
  tempoValue: int,
}

@spice
type exerciseSession = {
  name: string,
  projectName: string,
  tempo: tempo,
}

module FromRequest = {
  @spice
  type lastPracticed = {
    date?: @spice.codec(Util.Date.SpiceCodec.date) Date.t,
    tempo?: tempo,
  }

  @spice
  type t = {
    name?: string,
    active?: bool,
    topPriority?: bool,
    slowTempo?: int,
    fastTempo?: int,
    lastPracticed?: lastPracticed,
  }

  @spice
  type exerciseSession = {
    name?: string,
    tempo?: tempo,
  }
}
