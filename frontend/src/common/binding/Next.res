module Font = {
  type fontOptions = {
    subsets?: array<[#latin]>,
    display?: [#swap],
    variable?: string,
  }

  type font = {className: string, variable: string}

  @module("next/font/google") external fontInter: fontOptions => font = "Inter"
}

module Navigation = {
  module Router = {
    type t

    @send external push: (t, string) => unit = "push"
  }

  @module("next/navigation") external useRouter: unit => Router.t = "useRouter"
}
