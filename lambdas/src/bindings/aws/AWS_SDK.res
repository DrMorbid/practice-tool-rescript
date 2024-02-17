type aws
type cognitoIdentityServiceProvider

@module("aws-sdk") @new
external cognitoIdentityServiceProvider: unit => cognitoIdentityServiceProvider =
  "CognitoIdentityServiceProvider"
