@react.component
let default = () => {
  <Amplify.Authenticator>
    {({signOut, ?user}) =>
      <Mui.Box>
        <Mui.Typography variant={H1}>
          {user
          ->Option.flatMap(({?username}) => username)
          ->Option.map(username => `Hello ${username}`)
          ->Option.getOr("Unauthenticated!")
          ->Jsx.string}
        </Mui.Typography>
        <Mui.Button onClick=signOut> {"Sign out"->Jsx.string} </Mui.Button>
      </Mui.Box>}
  </Amplify.Authenticator>
}
