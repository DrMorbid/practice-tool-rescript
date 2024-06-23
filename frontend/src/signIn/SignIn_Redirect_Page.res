@react.component
let default = () => {
  let auth = ReactOidcContext.useAuth()

  let callBe = async accessToken => {
    let response = await Webapi.Fetch.fetchWithInit(
      "https://79vbkrpam5.execute-api.eu-central-1.amazonaws.com/project",
      Webapi.Fetch.RequestInit.make(
        ~method_=Get,
        ~headers=Webapi.Fetch.HeadersInit.make({
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": `Bearer ${accessToken}`,
        }),
        (),
      ),
    )

    if response->Webapi.Fetch.Response.ok {
      let jsonResponse = await response->Webapi.Fetch.Response.json

      Console.log2("FKR: the response is: %s", jsonResponse->JSON.stringify(~space=2))
    }
  }

  React.useEffect1(() => {
    auth.user->Option.map(({accessToken}) => accessToken)->Option.map(callBe)->ignore

    None
  }, [auth])

  <Mui.Typography> {"Welcome, authenticated user"->Jsx.string} </Mui.Typography>
}
