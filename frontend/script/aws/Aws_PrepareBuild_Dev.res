FsPromises.copyFile(
  ~source=Aws_Common.basePath ++ "/.env-dev",
  ~destination=Aws_Common.dotEnvFilePath,
)
->Promise.thenResolve(() => Console.log(".env file prepared for DEV"))
->ignore
