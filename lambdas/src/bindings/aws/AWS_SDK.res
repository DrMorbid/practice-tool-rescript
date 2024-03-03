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
    type putCommandInput<'a> = {@as("TableName") tableName?: string, @as("Item") item?: 'a}
    type put<'a> = {input?: putCommandInput<'a>}
    type putResult

    type getCommandInput<'a> = {@as("TableName") tableName?: string, @as("Key") key?: 'a}
    type get<'a> = {input?: getCommandInput<'a>}
    type getResult<'a> = {@as("Item") item?: 'a}

    type deleteCommandInput<'a> = {@as("TableName") tableName?: string, @as("Key") key?: 'a}
    type delete<'a> = {input?: deleteCommandInput<'a>}
    type deleteResult

    type queryCommandInput<'a> = {
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
    type query<'a> = {input?: queryCommandInput<'a>}
    type queryResult
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
    @send external sendPut: (t, Command.put<'a>) => promise<Command.putResult> = "send"
    @send external sendGet: (t, Command.get<'a>) => promise<Command.getResult<'b>> = "send"
    @send external sendDelete: (t, Command.delete<'a>) => promise<Command.deleteResult> = "send"
    @send external sendQuery: (t, Command.query<'a>) => promise<Command.queryResult> = "send"
  }

  @module("@aws-sdk/client-dynamodb") @new
  external makeDynamoDBClient: clientConfig => client = "DynamoDBClient"

  @module("@aws-sdk/lib-dynamodb")
  external dynamoDBDocumentClient: DynamoDBDocumentClient.parent = "DynamoDBDocumentClient"

  @module("@aws-sdk/lib-dynamodb") @new
  external makePutCommand: Command.putCommandInput<'a> => Command.put<'a> = "PutCommand"

  @module("@aws-sdk/lib-dynamodb") @new
  external makeGetCommand: Command.getCommandInput<'a> => Command.get<'a> = "GetCommand"

  @module("@aws-sdk/lib-dynamodb") @new
  external makeDeleteCommand: Command.deleteCommandInput<'a> => Command.delete<'a> = "DeleteCommand"

  @module("@aws-sdk/lib-dynamodb") @new
  external makeQueryCommand: Command.queryCommandInput<'a> => Command.query<'a> = "QueryCommand"
}
