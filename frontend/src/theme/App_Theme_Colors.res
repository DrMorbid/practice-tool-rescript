open Mui.Colors

let palette = prefersDarkMode =>
  {
    "primary": prefersDarkMode ? lightBlue["700"] : lightBlue["300"],
    "primaryLight": prefersDarkMode ? lightBlue["900"] : lightBlue["100"],
    "primaryDark": prefersDarkMode ? lightBlue["600"] : lightBlue["500"],
    "primaryContrastText": prefersDarkMode ? lightBlue["A700"] : lightBlue["A200"],
    "secondary": prefersDarkMode ? orange["800"] : yellow["500"],
    "secondaryLight": prefersDarkMode ? orange["900"] : yellow["200"],
    "secondaryDark": prefersDarkMode ? orange["800"] : yellow["700"],
    "secondaryContrastText": prefersDarkMode ? orange["900"] : yellow["A400"],
    "error": prefersDarkMode ? red["600"] : deepOrange["300"],
    "errorLight": prefersDarkMode ? red["800"] : deepOrange["100"],
    "errorDark": prefersDarkMode ? red["400"] : deepOrange["400"],
    "errorContrastText": prefersDarkMode ? red["A700"] : deepOrange["A400"],
    "warning": prefersDarkMode ? orange["800"] : orange["400"],
    "warningLight": prefersDarkMode ? orange["900"] : orange["200"],
    "warningDark": prefersDarkMode ? orange["800"] : orange["600"],
    "warningContrastText": prefersDarkMode ? orange["A700"] : orange["A400"],
    "info": prefersDarkMode ? lime["900"] : lime["400"],
    "infoLight": prefersDarkMode ? lime["900"] : lime["200"],
    "infoDark": prefersDarkMode ? lime["900"] : lime["600"],
    "infoContrastText": prefersDarkMode ? lime["A700"] : lime["A400"],
    "success": prefersDarkMode ? lightGreen["800"] : lightGreen["300"],
    "successLight": prefersDarkMode ? lightGreen["900"] : lightGreen["100"],
    "successDark": prefersDarkMode ? lightGreen["700"] : lightGreen["500"],
    "successContrastText": prefersDarkMode ? lightGreen["A700"] : lightGreen["A100"],
    "text": prefersDarkMode ? grey["50"] : grey["900"],
  }

let isLightMode = mode => mode == "light"
