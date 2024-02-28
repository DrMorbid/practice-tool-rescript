let toNotBlank = value =>
  value
  ->Option.map(String.trim)
  ->Option.filter(name => name->String.length > 0)
