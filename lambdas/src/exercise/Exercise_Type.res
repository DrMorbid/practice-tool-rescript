@spice
type tempo = | @spice.as("SLOW") Slow | @spice.as("FAST") Fast

@spice
type lastPracticed = {
  date?: @spice.codec(Utils.Date.SpiceCodec.date) Date.t,
  tempo?: tempo,
}

@spice
type toPractice = {
  exerciseName: string,
  tempo: tempo,
  tempoValue: int,
}

@spice
type t = {
  exerciseName?: string,
  active?: bool,
  topPriority?: bool,
  slowTempo?: int,
  fastTempo?: int,
  lastPracticed?: lastPracticed,
}

module Database = {
  module Save = {
    @spice
    type lastPracticed = {
      date: string,
      tempo: string,
    }

    @spice
    type t = {
      exerciseName: string,
      active: bool,
      topPriority: bool,
      slowTempo: int,
      fastTempo: int,
      lastPracticed?: lastPracticed,
    }
  }

  module Get = {
    @spice
    type lastPracticed = {
      date: @spice.codec(Utils.Date.SpiceCodec.date) Date.t,
      tempo: tempo,
    }

    @spice
    type t = {
      exerciseName: string,
      active: bool,
      topPriority: bool,
      slowTempo: int,
      fastTempo: int,
      lastPracticed?: lastPracticed,
    }
  }
}
