type fontOptions = {
  subsets?: array<[#latin]>,
  display?: [#swap],
  variable?: string,
}

type font = {className: string, variable: string}

@module("next/font/google") external fontInter: fontOptions => font = "Inter"
