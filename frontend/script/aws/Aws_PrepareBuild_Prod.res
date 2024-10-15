FsPromises.copyFile(
  ~source=Aws_Common.basePath ++ "/.env-prod",
  ~destination=Aws_Common.dotEnvFilePath,
)
->Promise.thenResolve(() => Console.log(".env file prepared for PROD"))
->ignore
