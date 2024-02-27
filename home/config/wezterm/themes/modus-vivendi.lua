local wezterm = require("wezterm")

local color_scheme = "Modus-Vivendi"
local colors = {
   foreground = "#ffffff",
   background = "#000000",
   selection_fg = "#ffffff",
   selection_bg = "#5c5c5c",

   cursor_fg = "#000000",
   cursor_bg = "#ffffff",
   cursor_border = "#ffffff",

   ansi = {
      "#000000",
      "#ff5f59",
      "#44bc44",
      "#d0bc00",
      "#2fafff",
      "#feacd0",
      "#00d3d0",
      "#ffffff",
   },
   brights = {
      "#595959",
      "#ff7f9f",
      "#70b900",
      "#fec43f",
      "#79a8ff",
      "#b6a0ff",
      "#6ae4b9",
      "#ffffff",
   },
}

return { color_scheme = color_scheme, colors = colors }
