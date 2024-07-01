type label = {
  message: string,
  description: option<string>,
}

@module("./_locales/en/messages.json") external en: Dict.t<label> = "default"
@module("./_locales/cs/messages.json") external cs: Dict.t<label> = "default"

let getTranslation = (language: Language.t) => {
  switch language {
  | En => en
  | Cs => cs
  }
  ->Dict.toArray
  ->Array.map(((messageId, {message, _})) => (messageId, message))
  ->Dict.fromArray
}
