open Dom.Storage2

type key = [#lastVisitedUrl]

let get = (key: key) => localStorage->getItem((key :> string))

let store = (key: key, value) => localStorage->setItem((key :> string), value)

let remove = (key: key) => localStorage->removeItem((key :> string))

let getLastVisitedUrl = () => #lastVisitedUrl->get

let storeLastVisitedUrl = () =>
  #lastVisitedUrl->store(Webapi.Dom.window->Webapi.Dom.Window.location->Webapi.Dom.Location.href)

let removeLastVisitedUrl = () => #lastVisitedUrl->remove
