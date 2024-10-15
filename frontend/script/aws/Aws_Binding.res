module Client = {
  type t
  type config = {apiVersion?: string}

  @module("@aws-sdk/client-s3") @new external makeS3Client: config => t = "S3Client"
}

type resultMetadata = {httpStatusCode: int}

module ListObjectsCommand = {
  type t
  type config = {@as("Bucket") bucket: string}
  module Result = {
    type contentsItem = {@as("Key") key: string}
    type t = {
      @as("Contents") contents?: array<contentsItem>,
      @as("$metadata") metadata: resultMetadata,
    }
  }

  @module("@aws-sdk/client-s3") @new
  external make: config => t = "ListObjectsCommand"

  @send external send: (Client.t, t) => promise<Result.t> = "send"
}

module DeleteObjectCommand = {
  type t
  type config = {@as("Bucket") bucket: string, @as("Key") key: string}
  module Result = {
    type t = {@as("$metadata") metadata: resultMetadata}
  }

  @module("@aws-sdk/client-s3") @new
  external make: config => t = "DeleteObjectCommand"

  @send external send: (Client.t, t) => promise<Result.t> = "send"
}

module Upload = {
  type t
  type params = {
    @as("Bucket") bucket: string,
    @as("Key") key: string,
    @as("Body") body: FsPromises.buffer,
    @as("ContentType") contentType: string,
  }
  type options = {
    client: Client.t,
    params: params,
    queueSize?: int,
    partSize?: int,
    leavePartsOnError?: bool,
  }
  type event = [#httpUploadProgress]
  type progress = {
    @as("Bucket") bucket: string,
    @as("Key") key: string,
    loaded: float,
    part: float,
    total: float,
  }

  @module("@aws-sdk/lib-storage") @new
  external make: options => t = "Upload"

  @send external on: (t, event, progress => unit) => unit = "on"
  @send external done: t => promise<unit> = "done"
}
