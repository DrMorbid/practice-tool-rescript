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
