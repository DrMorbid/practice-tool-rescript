type error = {
  status: int,
  message: string,
}

let fetch = async (~auth: ReactOidcContext.Auth.t, ~method, path: Route.BackEnd.t) => {
  let accessToken = auth.user->Option.map(({accessToken}) => accessToken)

  let headers = [("Accept", "application/json"), ("Content-Type", "application/json")]
  let headers =
    accessToken
    ->Option.map(accessToken => headers->Array.concat([("Authorization", `Bearer ${accessToken}`)]))
    ->Option.getOr(headers)

  let response = await Webapi.Fetch.fetchWithInit(
    `${EnvVar.backEndUrl}${(path :> string)}`,
    Webapi.Fetch.RequestInit.make(
      ~method_=method,
      ~headers=Webapi.Fetch.HeadersInit.makeWithArray(headers),
      (),
    ),
  )

  let responseBody = await response->Webapi.Fetch.Response.json

  if response->Webapi.Fetch.Response.ok {
    Ok(responseBody)
  } else {
    Error({
      status: response->Webapi.Fetch.Response.status,
      message: responseBody->JSON.stringify,
    })
  }
}
