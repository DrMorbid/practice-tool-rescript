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
        contrastText: palette["onPrimary"],
      },
      secondary: {
        main: palette["secondary"],
        contrastText: palette["onSecondary"],
      },
      error: {
        main: palette["error"],
        contrastText: palette["onError"],
      },
      warning: {
        main: palette["warning"],
        contrastText: palette["onWarning"],
      },
      info: {
        main: palette["info"],
        contrastText: palette["onInfo"],
      },
      success: {
        main: palette["success"],
        contrastText: palette["onSuccess"],
      },
      background: {
        default: palette["background"],
        paper: palette["backgroundPaper"],
      },
      text: {
        primary: palette["textPrimary"],
        secondary: palette["textSecondary"],
      },
    },
    components: {
      muiAlert: {
        styleOverrides: {
          filledSuccess: {color: palette["onSuccess"], backgroundColor: palette["success"]},
          filledInfo: {color: palette["onInfo"], backgroundColor: palette["info"]},
          filledWarning: {color: palette["onWarning"], backgroundColor: palette["warning"]},
          filledError: {color: palette["onError"], backgroundColor: palette["error"]},
        },
      },
      muiListItemIcon: {
        styleOverrides: {
          root: {color: palette["textPrimary"]},
        },
      },
      muiButton: {
        styleOverrides: ?(
          if prefersDarkMode {
            Some({
              contained: {
                backgroundColor: palette["info"],
              },
              containedPrimary: {
                backgroundColor: palette["primary"],
              },
              outlined: {
                borderColor: palette["info"],
              },
              outlinedPrimary: {
                color: palette["info"],
                borderColor: palette["info"],
              },
              textPrimary: {
                color: palette["info"],
              },
            })
          } else {
            None
          }
        ),
      },
      muiChip: {
        styleOverrides: ?(
          if prefersDarkMode {
            Some({
              outlinedPrimary: {
                color: palette["info"],
                borderColor: palette["info"],
              },
              deleteIconOutlinedColorPrimary: {
                color: palette["info"],
              },
            })
          } else {
            None
          }
        ),
      },
    },
  })

  MuiStyles.responsiveFontSizes(theme)
}
