module AppRouterCacheProvider = {
  type options = {enableCssLayer?: bool}

  @react.component @module("@mui/material-nextjs/v14-appRouter")
  external make: (~options: options=?, ~children: Jsx.element) => React.element =
    "AppRouterCacheProvider"
}
