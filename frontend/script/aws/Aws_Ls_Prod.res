open Aws_Common

ls(Production)
->Promise.thenResolve(files => files->Array.forEach(file => Console.log(file)))
->ignore
