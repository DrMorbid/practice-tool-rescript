module DynamoDB = {
  type client
  type credentials = {
    accessKeyId?: string,
    secretAccessKey?: string,
    credentialScope?: string,
    expiration?: Date.t,
    sessionToken?: string,
  }
  type httpAuthScheme = {schemeId: string}
  type retryStrategy = {mode?: string}
  type clientConfig = {
    apiVersion?: string,
    base64Decoder?: string => array<int>,
    base64Encoder?: array<int> => string,
    credentials?: credentials,
    customUserAgent?: string,
    defaultsMode?: [#standard | #"in-region" | #"cross-region" | #mobile | #auto | #legacy],
    disableHostPrefix?: bool,
    endpoint?: string,
    endpointCacheSize?: int,
    endpointDiscoveryEnabled?: bool,
    endpointDiscoveryEnabledProvider?: unit => promise<bool>,
    httpAuthSchemes?: array<httpAuthScheme>,
    maxAttempts?: int,
    region?: string,
    retryMode?: string,
    retryStrategy?: retryStrategy,
    runtime?: string,
    serviceId?: string,
    signingEscapePath?: bool,
    signingRegion?: string,
    systemClockOffset?: int,
    useDualstackEndpoint?: bool,
    useFipsEndpoint?: bool,
    utf8Decoder?: string => array<int>,
    utf8Encoder?: array<int> => string,
  }

  module Command = {
    type item = {@as("user-id") userId?: string, name?: string}
    type putCommandInput = {@as("TableName") tableName?: string, @as("Item") item?: item}
    type put = {input?: putCommandInput}
    type result
  }

  module DynamoDBDocumentClient = {
    type parent
    type t
    type marshallOptions = {
      convertEmptyValues?: bool,
      removeUndefinedValues?: bool,
      convertClassInstanceToMap?: bool,
      convertTopLevelContainer?: bool,
    }
    type unmarshallOptions = {
      wrapNumbers?: bool,
      convertWithoutMapWrapper?: bool,
    }
    type translateConfig = {
      marshallOptions?: marshallOptions,
      unmarshallOptions?: unmarshallOptions,
    }

    @send external from: (parent, client, ~translateConfig: translateConfig=?) => t = "from"
    @send external sendPut: (t, Command.put) => promise<Command.result> = "send"
  }

  @module("@aws-sdk/client-dynamodb") @new
  external makeDynamoDBClient: clientConfig => client = "DynamoDBClient"

  @module("@aws-sdk/lib-dynamodb")
  external dynamoDBDocumentClient: DynamoDBDocumentClient.parent = "DynamoDBDocumentClient"

  @module("@aws-sdk/lib-dynamodb") @new
  external makePutCommand: Command.putCommandInput => Command.put = "PutCommand"
}
