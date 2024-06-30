let palette = prefersDarkMode =>
  {
    "primary": prefersDarkMode ? "#116466" : "#026670",
    "secondary": prefersDarkMode ? "#D9B08C" : "#BA9718",
    "error": prefersDarkMode ? "#AD4320" : "#E35437",
    "warning": prefersDarkMode ? "#FFCB9A" : "#FCE181",
    "info": prefersDarkMode ? "#D1E8E2" : "#026670",
    "success": prefersDarkMode ? "#116466" : "#9FEDD7",
    "textPrimary": prefersDarkMode ? "#D1E8E2" : "#000C0E",
    "textSecondary": prefersDarkMode ? "#E1F8FA" : "#161206",
    "background": prefersDarkMode ? "#2C3531" : "#EDEAE5",
    "backgroundPaper": prefersDarkMode ? "#1E2522" : "#FAF9F7",
    "backgroundSnackbar": prefersDarkMode ? "#E8F3F0" : "#002327",
    "colorSnackbar": prefersDarkMode ? "#2C3531" : "#F6FAF9",
  }

let isLightMode = mode => mode == "light"
