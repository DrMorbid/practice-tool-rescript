let palette = prefersDarkMode =>
  {
    "primary": prefersDarkMode ? "#116466" : "#026670",
    "onPrimary": prefersDarkMode ? "#FFF8F1" : "#FFFEF1",
    "secondary": prefersDarkMode ? "#D9B08C" : "#B48D04",
    "onSecondary": prefersDarkMode ? "#062424" : "#01262A",
    "error": prefersDarkMode ? "#AD4320" : "#E35437",
    "onError": prefersDarkMode ? "#FFF8F1" : "#2A2601",
    "warning": prefersDarkMode ? "#FFCB9A" : "#FCE181",
    "onWarning": prefersDarkMode ? "#062424" : "#01262A",
    "info": prefersDarkMode ? "#116466" : "#FEF9C7",
    "onInfo": prefersDarkMode ? "#FFF8F1" : "#01262A",
    "success": prefersDarkMode ? "#D1E8E2" : "#9FEDD7",
    "onSuccess": prefersDarkMode ? "#062424" : "#2A2601",
    "textPrimary": prefersDarkMode ? "#DBF8F9" : "#01262A",
    "textSecondary": prefersDarkMode ? "#FFF8F1" : "#2A2601",
    "background": prefersDarkMode ? "#2C3531" : "#EDEAE5",
    "backgroundPaper": prefersDarkMode ? "#171C1A" : "#FAF9F7",
    "backgroundSnackbar": prefersDarkMode ? "#E8F3F0" : "#002327",
    "onBackgroundSnackbar": prefersDarkMode ? "#062424" : "#FFFEF1",
  }

let isLightMode = mode => mode == "light"
