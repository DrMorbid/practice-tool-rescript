open Mui.ThemeOptions
open Mui.Theme

module Colors = App_Theme_Colors
module Typography = App_Theme_Typography
module Classes = App_Theme_Classes

let darkModeMediaQuery = "(prefers-color-scheme: dark)"

module Breakpoint = {
  let values: Mui.ThemeOptions.breakpointValues = {
    xs: 0.,
    sm: 600.,
    md: 900.,
    lg: 1200.,
    xl: 1536.,
  }

  let mediaQuery = (~down=false, breakpointValue) =>
    `(${down ? "max-width" : "min-width"}: ${breakpointValue
      ->Option.map(Float.toString(_))
      ->Option.getOr("0")}px)`

  let xsUp = values.xs->mediaQuery
  let smUp = values.sm->mediaQuery
  let mdUp = values.md->mediaQuery
  let lgUp = values.lg->mediaQuery
  let xlUp = values.xl->mediaQuery
  let xsDown = values.xs->mediaQuery(~down=true)
  let smDown = values.sm->mediaQuery(~down=true)
  let mdDown = values.md->mediaQuery(~down=true)
  let lgDown = values.lg->mediaQuery(~down=true)
  let xlDown = values.xl->mediaQuery(~down=true)
}

let theme = (~prefersDarkMode) => {
  let palette = Colors.palette(prefersDarkMode)

  let theme = create({
    typography: {
      fontFamily: Typography.fontFamily,
    },
    breakpoints: {
      values: Breakpoint.values,
    },
    palette: {
      mode: prefersDarkMode ? "dark" : "light",
      primary: {
        main: palette["primary"],
      },
      secondary: {
        main: palette["secondary"],
      },
      error: {
        main: palette["error"],
      },
      warning: {
        main: palette["warning"],
      },
      info: {
        main: palette["info"],
      },
      success: {
        main: palette["success"],
      },
      background: {
        default: palette["background"],
      },
      text: {
        primary: palette["textPrimary"],
        secondary: palette["textSecondary"],
      },
    },
  })

  MuiStyles.responsiveFontSizes(theme)
}
