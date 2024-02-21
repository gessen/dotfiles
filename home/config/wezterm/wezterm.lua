local wezterm = require("wezterm")
local config = {}
local act = wezterm.action

config.check_for_updates = false
-- config.term = "wezterm"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 23.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.window_frame = {
   font = wezterm.font("JetBrains Mono", { weight = "Bold" }),
   font_size = 13.0,
}
config.tab_bar_at_bottom = true
config.tab_max_width = 60
config.switch_to_last_active_tab_when_closing_tab = true

config.window_background_opacity = 1.0
config.window_close_confirmation = "NeverPrompt"
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

config.default_cursor_style = "BlinkingBar"
config.animation_fps = 10

config.enable_scroll_bar = true
config.scrollback_lines = 10000

config.initial_cols = 110
config.initial_rows = 36

local process_icons = {
   ["zsh"] = wezterm.nerdfonts.dev_terminal,
   ["bash"] = wezterm.nerdfonts.cod_terminal_bash,
   ["emacs"] = wezterm.nerdfonts.custom_emacs,
   ["emacs-29.1"] = wezterm.nerdfonts.custom_emacs,
   ["emacsclient"] = wezterm.nerdfonts.custom_emacs,
   ["vim"] = wezterm.nerdfonts.dev_vim,
   ["make"] = wezterm.nerdfonts.seti_cpp,
   ["ninja"] = wezterm.nerdfonts.seti_cpp,
   ["cc"] = wezterm.nerdfonts.seti_c,
   ["gcc"] = wezterm.nerdfonts.seti_c,
   ["clang"] = wezterm.nerdfonts.seti_c,
   ["c++"] = wezterm.nerdfonts.seti_cpp,
   ["g++"] = wezterm.nerdfonts.seti_cpp,
   ["clang++"] = wezterm.nerdfonts.seti_cpp,
   ["cargo"] = wezterm.nerdfonts.seti_rust,
   ["rustc"] = wezterm.nerdfonts.seti_rust,
   ["ruby"] = wezterm.nerdfonts.fae_ruby,
   ["sudo"] = wezterm.nerdfonts.fa_hashtag,
   ["tmux"] = wezterm.nerdfonts.cod_terminal_tmux,
   ["git"] = wezterm.nerdfonts.dev_git,
   ["htop"] = wezterm.nerdfonts.md_chart_donut_variant,
   ["sql2"] = wezterm.nerdfonts.dev_sqllite,
   ["wget"] = wezterm.nerdfonts.md_arrow_down_box,
   ["curl"] = wezterm.nerdfonts.md_arrow_down_box,
   ["docker"] = wezterm.nerdfonts.linux_docker,
   ["docker-compose"] = wezterm.nerdfonts.linux_docker,
}

local function basename(s)
   if not s then return "[?]" end
   return string.gsub(string.format("%s", s), "^(.+)[/\\]([^/\\]+)([/\\]*)$", "%2")
end

local function get_process(tab)
   local process_name = basename(tab.active_pane.foreground_process_name)
   return process_icons[process_name] or string.format("[%s]", process_name)
end

local function get_cwd(tab)
   local cwd_uri = tab.active_pane.current_working_dir or ""
   local home_path = string.format("%s/", os.getenv("HOME"))

   return cwd_uri.file_path == home_path and "" or basename(cwd_uri.file_path)
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
   local has_unseen_output = false
   if not tab.is_active then
      for _, pane in ipairs(tab.panes) do
         if pane.has_unseen_output then
            has_unseen_output = true
            break
         end
      end
   end

   local title = string.format("%s ~ %s", get_process(tab), get_cwd(tab))

   if has_unseen_output then
      return {
         { Foreground = { Color = "#28719c" } },
         { Text = title },
      }
   end

   return title
end)

wezterm.on("update-right-status", function(window, pane)
   local leader = ""
   if window:leader_is_active() then leader = wezterm.nerdfonts.fa_keyboard_o end

   local cwd = basename(pane:get_current_working_dir())
   local cmd = basename(pane:get_foreground_process_name())
   local hostname = wezterm.hostname()
   local time = wezterm.strftime("%H:%M")

   window:set_right_status(wezterm.format({
      { Text = leader },
      { Text = " | " },
      { Text = wezterm.nerdfonts.md_folder .. " " .. cwd },
      { Text = " | " },
      { Foreground = { Color = "FFB86C" } },
      { Text = wezterm.nerdfonts.cod_debug_start .. " " .. cmd },
      "ResetAttributes",
      { Text = " | " },
      { Text = wezterm.nerdfonts.oct_person .. " " .. hostname },
      { Text = " | " },
      { Text = wezterm.nerdfonts.md_clock .. " " .. time },
   }))
end)

config.enable_kitty_keyboard = true
config.leader = { key = "S", mods = "CTRL", timeout_milliseconds = 3000 }
config.keys = {
   { key = "0", mods = "CTRL", action = "DisableDefaultAssignment" },
   { key = "-", mods = "CTRL", action = "DisableDefaultAssignment" },
   { key = "=", mods = "CTRL", action = "DisableDefaultAssignment" },
   { key = "PageUp", mods = "CTRL", action = "DisableDefaultAssignment" },
   { key = "PageDown", mods = "CTRL", action = "DisableDefaultAssignment" },
   { key = "PageUp", mods = "SHIFT", action = "DisableDefaultAssignment" },
   { key = "PageDown", mods = "SHIFT", action = "DisableDefaultAssignment" },

   { key = "LeftArrow", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
   { key = "RightArrow", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(1) },
   { key = "PageUp", mods = "SHIFT|CTRL", action = act.ScrollByPage(-1) },
   { key = "PageDown", mods = "SHIFT|CTRL", action = act.ScrollByPage(1) },
   { key = "Home", mods = "SHIFT|CTRL", action = act.ScrollToTop },
   { key = "End", mods = "SHIFT|CTRL", action = act.ScrollToBottom },

   { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
   { key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
   { key = "n", mods = "LEADER", action = act.ActivatePaneDirection("Next") },
   { key = "p", mods = "LEADER", action = act.ActivatePaneDirection("Prev") },
   { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
   { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

   { key = "q", mods = "CTRL", action = act.SendKey({ key = "q", mods = "CTRL" }) },
   { key = "/", mods = "CTRL", action = act.SendKey({ key = "/", mods = "CTRL" }) },
}

-- local theme = require("themes.modus-vivendi")
local theme = require("themes.tokyo-night")
config.color_scheme = theme.color_scheme
config.colors = theme.colors

return config
