module SpiceCodec = {
  let dateEncoder = date => date->Date.toISOString->JSON.Encode.string

  let dateDecoder = date => {
    let result = date->JSON.Decode.string->Option.map(Date.fromString)

    switch result {
    | Some(result) if result->Date.toString == "Invalid Date" =>
      Error({
        Spice.path: "",
        message: "The date is invalid",
        value: date,
      })
    | Some(result) => Ok(result)
    | None =>
      Error({
        Spice.path: "",
        message: "The date is not a string",
        value: date,
      })
    }
  }

  let date = (dateEncoder, dateDecoder)
}
