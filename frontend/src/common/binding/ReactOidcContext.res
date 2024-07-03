module Auth = {
  type profile = {sub: string}

  type user = {
    profile: profile,
    @as("access_token") accessToken: string,
    @as("id_token") idToken?: string,
    @as("session_state") sessionState?: string,
    @as("refresh_token") refreshToken?: string,
    @as("token_type") tokenType: string,
    scope?: string,
    expires_at?: int,
  }

  type error = {message: string}

  type t = {
    activeNavigator?: [#signinSilent | #signoutRedirect],
    isLoading: bool,
    error?: error,
    isAuthenticated: bool,
    user: Nullable.t<user>,
  }

  @send external removeUser: (t, unit) => unit = "removeUser"
  @send external signinRedirect: (t, unit) => unit = "signinRedirect"
  @send external signOutRedirect: (t, unit) => unit = "signOutRedirect"
}

@module("react-oidc-context") external useAuth: unit => Auth.t = "useAuth"
@module("react-oidc-context") external hasAuthParams: unit => bool = "hasAuthParams"

module AuthProvider = {
  @module("react-oidc-context") @react.component
  external make: (
    ~authority: string,
    ~client_id: string,
    ~redirect_uri: string,
    ~scope: string=?,
    ~onSigninCallback: Auth.user => unit=?,
    ~skipSigninCallback: bool=?,
    ~children: Jsx.element,
  ) => Jsx.element = "AuthProvider"
}
