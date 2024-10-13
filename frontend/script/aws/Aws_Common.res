open Aws_Binding

module Environment = {
  type t = Development | Production

  let toString = environment =>
    switch environment {
    | Development => "DEV"
    | Production => "PROD"
    }
}
let getBucket = (environment: Environment.t) =>
  switch environment {
  | Development => "practice-tool-dev"
  | Production => "practice-tool"
  }

let ls = async environment => {
  let {?contents} =
    await Client.makeS3Client({})->ListObjectsCommand.send(
      ListObjectsCommand.make({bucket: environment->getBucket}),
    )

  contents->Option.getOr([])->Array.map(({key}) => key)
}

let rm = async environment => {
  let bucket = environment->getBucket

  Console.log2("Deleting content of %s bucket", environment->Environment.toString)

  let files = await environment->ls

  let results =
    await files
    ->Array.map(async key => {
      let result =
        await Client.makeS3Client({})->DeleteObjectCommand.send(
          DeleteObjectCommand.make({bucket, key}),
        )

      if result.metadata.httpStatusCode >= 400 {
        Console.error3("Failed to delete a file %s: %o", key, result)
        Some(key)
      } else {
        None
      }
    })
    ->Promise.all

  if results->Array.keepSome->Array.length == 0 {
    Console.log2("%d files successfully deleted", files->Array.length)
  }
}
