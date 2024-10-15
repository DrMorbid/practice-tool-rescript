open Aws_Common

ls(Development)
->Promise.thenResolve(files => files->Array.forEach(file => Console.log(file)))
->ignore
