let palette = prefersDarkMode =>
  {
    "primary": prefersDarkMode ? "#116466" : "#026670",
    "onPrimary": prefersDarkMode ? "#FFF8F1" : "#FFFEF1",
    "secondary": prefersDarkMode ? "#D9B08C" : "#B48D04",
    "onSecondary": prefersDarkMode ? "#062424" : "#01262A",
    "error": prefersDarkMode ? "#AD4320" : "#E35437",
    "onError": prefersDarkMode ? "#062424" : "#01262A",
    "warning": prefersDarkMode ? "#FFCB9A" : "#FCE181",
    "onWarning": prefersDarkMode ? "#062424" : "#01262A",
    "info": prefersDarkMode ? "#D1E8E2" : "#FEF9C7",
    "onInfo": prefersDarkMode ? "#20150B" : "#01262A",
    "success": prefersDarkMode ? "#116466" : "#9FEDD7",
    "onSuccess": prefersDarkMode ? "#FFF8F1" : "#2A2601",
    "textPrimary": prefersDarkMode ? "#DBF8F9" : "#01262A",
    "textSecondary": prefersDarkMode ? "#FFF8F1" : "#2A2601",
    "background": prefersDarkMode ? "#2C3531" : "#EDEAE5",
    "backgroundPaper": prefersDarkMode ? "#1E2522" : "#FAF9F7",
    "backgroundSnackbar": prefersDarkMode ? "#E8F3F0" : "#002327",
  }

let isLightMode = mode => mode == "light"
