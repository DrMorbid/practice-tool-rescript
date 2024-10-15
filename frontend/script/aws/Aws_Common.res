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
    Console.log3(
      "%d files successfully deleted from %s bucket",
      files->Array.length,
      environment->Environment.toString,
    )
  }
}

let cp = async environment => {
  let bucket = environment->getBucket

  Console.log2("Uploading frontend to %s bucket", environment->Environment.toString)

  let files = await FsPromises.readdir(
    "/home/filip/development/practice-tool-rescript/frontend/out",
    ~options={withFileTypes: true, recursive: true},
  )

  let results =
    await files
    ->Array.filterMap(file =>
      if file->FsPromises.isDirectory {
        None
      } else {
        Some(`${file.parentPath}/${file.name}`)
      }
    )
    ->Array.map(async filePath => {
      let body = await filePath->FsPromises.readFile

      (
        {
          bucket,
          key: filePath->String.substringToEnd(~start=filePath->String.indexOf("/out") + 5),
          body,
          contentType: filePath->Mime.lookup->Nullable.toOption->Option.getOr(""),
        }: Aws_Binding.Upload.params
      )
    })
    ->Array.map(async params => {
      let params = await params

      Upload.make({
        client: Client.makeS3Client({}),
        params,
        queueSize: 3,
      })
    })
    ->Array.map(async upload => {
      let upload = await upload

      await upload->Upload.done
    })
    ->Promise.all

  Console.log3(
    "%d files successfully uploaded to %s bucket",
    results->Array.length,
    environment->Environment.toString,
  )
}

let basePath = "/home/filip/development/practice-tool-rescript/frontend"
let dotEnvFilePath = `${basePath}/.env`
