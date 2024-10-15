open Aws_Common

rm(Production)->Promise.thenResolve(() => cp(Production))->ignore
