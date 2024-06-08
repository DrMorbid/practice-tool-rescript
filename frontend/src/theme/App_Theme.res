open Mui.ThemeOptions
open Mui.Theme

module Colors = App_Theme_Colors
module Typography = App_Theme_Typography

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

  create({
    typography: {
      fontFamily: Typography.fontFamily,
      h1: Obj.magic({
        "fontFamily": Typography.h1.fontFamily,
        "fontSize": Typography.h1.fontSize,
        "fontWeight": Typography.h1.fontWeight,
      }),
      h2: Obj.magic({
        "fontFamily": Typography.h2.fontFamily,
        "fontSize": Typography.h2.fontSize,
        "fontWeight": Typography.h2.fontWeight,
      }),
      h3: Obj.magic({
        "fontFamily": Typography.h3.fontFamily,
        "fontSize": Typography.h3.fontSize,
        "fontWeight": Typography.h3.fontWeight,
      }),
      h4: Obj.magic({
        "fontFamily": Typography.h4.fontFamily,
        "fontSize": Typography.h4.fontSize,
        "fontWeight": Typography.h4.fontWeight,
      }),
      h5: Obj.magic({
        "fontFamily": Typography.h5.fontFamily,
        "fontSize": Typography.h5.fontSize,
        "fontWeight": Typography.h5.fontWeight,
      }),
      h6: Obj.magic({
        "fontFamily": Typography.h6.fontFamily,
        "fontSize": Typography.h6.fontSize,
        "fontWeight": Typography.h6.fontWeight,
      }),
    },
    breakpoints: {
      values: Breakpoint.values,
    },
    palette: {
      mode: prefersDarkMode ? "dark" : "light",
      primary: {
        main: palette["primary"],
        light: palette["primaryLight"],
        dark: palette["primaryDark"],
        contrastText: palette["primaryContrastText"],
      },
      secondary: {
        main: palette["secondary"],
        light: palette["secondaryLight"],
        dark: palette["secondaryDark"],
        contrastText: palette["secondaryContrastText"],
      },
      error: {
        main: palette["error"],
        light: palette["errorLight"],
        dark: palette["errorDark"],
        contrastText: palette["errorContrastText"],
      },
      warning: {
        main: palette["warning"],
        light: palette["warningLight"],
        dark: palette["warningDark"],
        contrastText: palette["warningContrastText"],
      },
      info: {
        main: palette["info"],
        light: palette["infoLight"],
        dark: palette["infoDark"],
        contrastText: palette["infoContrastText"],
      },
      success: {
        main: palette["success"],
        light: palette["successLight"],
        dark: palette["successDark"],
        contrastText: palette["successContrastText"],
      },
    },
  })
}
