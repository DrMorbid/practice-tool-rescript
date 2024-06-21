type t

module Authenticator = {
  type user = {username?: string}
  type authProps = {signOut: ReactEvent.Mouse.t => unit, user?: user}

  @module("@aws-amplify/ui-react") @react.component
  external make: (~children: authProps => Jsx.element) => Jsx.element = "Authenticator"
}

module Configuration = {
  type cognitoConfig = {
    userPoolClientId?: string,
    userPoolId?: string,
  }
  type authConfig = {@as("Cognito") cognito?: cognitoConfig}
  type resourceConfig = {@as("Auth") auth?: authConfig}
  type libraryOptions

  @send
  external configure: (t, resourceConfig, ~libraryOptions: libraryOptions=?) => unit = "configure"
}

@module("aws-amplify") external amplify: t = "Amplify"
