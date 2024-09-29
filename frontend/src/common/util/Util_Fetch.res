module Response = Util_Fetch_Response
open Response

let fetch = async (
  ~body: option<JSON.t>=?,
  ~auth: ReactOidcContext.Auth.t,
  ~method,
  ~responseDecoder: JSON.t => result<'a, Spice.decodeError>,
  ~router,
  path: Route.BackEnd.t,
) => {
  let accessToken = auth.user->Nullable.toOption->Option.map(({accessToken}) => accessToken)

  let headers = [("Accept", "application/json"), ("Content-Type", "application/json")]
  let headers =
    accessToken
    ->Option.map(accessToken => headers->Array.concat([("Authorization", `Bearer ${accessToken}`)]))
    ->Option.getOr(headers)

  try {
    let response = await Webapi.Fetch.fetchWithInit(
      `${EnvVar.backEndUrl}${path->Route.BackEnd.toString}`,
      Webapi.Fetch.RequestInit.make(
        ~method_=method,
        ~headers=Webapi.Fetch.HeadersInit.makeWithArray(headers),
        ~body=?body->Option.map(body => Webapi.Fetch.BodyInit.make(body->JSON.stringify)),
        (),
      ),
    )

    let responseBody = await response->Webapi.Fetch.Response.json

    let decodeErrorToError = ({path, message, value}: Spice.decodeError) => {
      message: `${path}, ${message}, ${value->JSON.stringify(~space=2)}`,
    }

    if response->Webapi.Fetch.Response.ok {
      responseBody
      ->responseDecoder
      ->Result.mapError(decodeError => decodeError->decodeErrorToError)
    } else {
      Error({
        let error = switch responseBody->error_decode {
        | Ok(error) => error
        | Error(decodeError) => decodeError->decodeErrorToError
        }

        Console.error2("Fetch returned error response: %o", error)

        if response->Webapi.Fetch.Response.status == 401 {
          Util_LocalStorage.storeLastVisitedUrl()
          router->Route.FrontEnd.push(~route=SignIn)
        }

        error
      })
    }
  } catch {
  | Exn.Error(error) => {
      Console.error2("Fetch failed: %o", error)

      Error({
        message: error
        ->Exn.name
        ->Option.flatMap(name => error->Exn.message->Option.map(message => `${name}: ${message}`))
        ->Option.getOr("Unexpected error occurred"),
      })
    }
  }
}
