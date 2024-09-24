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

  module URLSearchParams = {
    type t

    @send external entries: t => Iterator.t<(string, string)> = "entries"
    @send
    external forEach: (t, (~value: string, ~key: string, ~searchParams: t) => unit) => unit =
      "forEach"
    @send external get: (t, string) => Nullable.t<string> = "get"
    @send external getAll: (t, string) => array<string> = "getAll"
    @send external has: (t, ~name: string, ~value: string) => bool = "has"
    @send external keys: t => Iterator.t<string> = "keys"
    @send external toString: t => string = "toString"
    @send external values: t => Iterator.t<string> = "values"
  }

  @module("next/navigation") external useSearchParams: unit => URLSearchParams.t = "useSearchParams"
}
