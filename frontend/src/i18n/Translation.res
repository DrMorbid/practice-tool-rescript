type label = {
  message: string,
  description: option<string>,
}

@module("./_locales/en/messages.json") external en: Dict.t<label> = "default"
@module("./_locales/cs/messages.json") external cs: Dict.t<label> = "default"

let getTranslation = (locale: Intl.Locale.t) => {
  switch locale->Intl.Locale.language {
  | "cs" | "cs-CZ" | "cs_CZ" => cs
  | _ => en
  }
  ->Dict.toArray
  ->Array.map(((messageId, {message, _})) => (messageId, message))
  ->Dict.fromArray
}
