type options = {
  withFileTypes?: bool,
  recursive?: bool,
}

type dirent = {
  name: string,
  parentPath: string,
}

type buffer

@module("fs/promises")
external readdir: (string, ~options: options=?) => promise<array<dirent>> = "readdir"

@send external isDirectory: dirent => bool = "isDirectory"

@module("fs/promises") external readFile: string => promise<buffer> = "readFile"

@module("fs/promises")
external copyFile: (~source: string, ~destination: string) => promise<unit> = "copyFile"
