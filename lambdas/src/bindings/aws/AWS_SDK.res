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
    type putCommandInput = {@as("TableName") tableName?: string, @as("Item") item?: JSON.t}
    type put = {input?: putCommandInput}
    type putResult

    type getCommandInput = {@as("TableName") tableName?: string, @as("Key") key?: JSON.t}
    type get = {input?: getCommandInput}
    type getResult = {@as("Item") item?: JSON.t}

    type deleteCommandInput = {@as("TableName") tableName?: string, @as("Key") key?: JSON.t}
    type delete = {input?: deleteCommandInput}
    type deleteResult

    type queryCommandInput = {
      @as("TableName") tableName?: string,
      @as("KeyConditionExpression") keyConditionExpression?: string,
      @as("ExpressionAttributeNames") expressionAttributeNames?: Dict.t<string>,
      @as("ExpressionAttributeValues") expressionAttributeValues?: Dict.t<string>,
      @as("Limit") limit?: int,
      @as("ReturnConsumedCapacity")
      returnConsumedCapacity?: [#INDEXES | #TOTAL | #NONE],
      @as("Select")
      select?: [
        | #ALL_ATTRIBUTES
        | #ALL_PROJECTED_ATTRIBUTES
        | #COUNT
        | #SPECIFIC_ATTRIBUTES
      ],
    }
    type query = {input?: queryCommandInput}
    type queryResult = {
      @as("Count") count: int,
      @as("Items") items: array<JSON.t>,
      @as("ScannedCount") scannedCount: int,
    }
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
    @send external sendPut: (t, Command.put) => promise<Command.putResult> = "send"
    @send external sendGet: (t, Command.get) => promise<Command.getResult> = "send"
    @send external sendDelete: (t, Command.delete) => promise<Command.deleteResult> = "send"
    @send external sendQuery: (t, Command.query) => promise<Command.queryResult> = "send"
  }

  @module("@aws-sdk/client-dynamodb") @new
  external makeDynamoDBClient: clientConfig => client = "DynamoDBClient"

  @module("@aws-sdk/lib-dynamodb")
  external dynamoDBDocumentClient: DynamoDBDocumentClient.parent = "DynamoDBDocumentClient"

  @module("@aws-sdk/lib-dynamodb") @new
  external makePutCommand: Command.putCommandInput => Command.put = "PutCommand"

  @module("@aws-sdk/lib-dynamodb") @new
  external makeGetCommand: Command.getCommandInput => Command.get = "GetCommand"

  @module("@aws-sdk/lib-dynamodb") @new
  external makeDeleteCommand: Command.deleteCommandInput => Command.delete = "DeleteCommand"

  @module("@aws-sdk/lib-dynamodb") @new
  external makeQueryCommand: Command.queryCommandInput => Command.query = "QueryCommand"
}
