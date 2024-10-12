module Content = Session_Save_Page_Content

@react.component
let default = () => {
  <React.Suspense>
    <Content />
  </React.Suspense>
}
