let palette = prefersDarkMode =>
  {
    "primary": prefersDarkMode ? "#116466" : "#026670",
    "secondary": prefersDarkMode ? "#D9B08C" : "#9FEDD7",
    "error": prefersDarkMode ? "#BF360C" : "#EF6C00",
    "warning": prefersDarkMode ? "#FFCB9A" : "#FCE181",
    "info": prefersDarkMode ? "#D1E8E2" : "#9FEDD7",
    "success": prefersDarkMode ? "#116466" : "#026670",
    "textPrimary": prefersDarkMode ? "#D1E8E2" : "rgba(0, 0, 0, 0.87)",
    "textSecondary": prefersDarkMode ? "#DAECE7" : "rgba(0, 0, 0, 0.6)",
    "background": prefersDarkMode ? "#2C3531" : "#EDEAE5",
  }

let isLightMode = mode => mode == "light"
