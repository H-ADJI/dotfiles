local wezterm = require("wezterm") ---@type Wezterm
local config = wezterm.config_builder() ---@type Config

config.color_scheme = "Catppuccin Latte"

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold", italic = false })
config.font_size = 15

config.enable_tab_bar = false
config.window_padding = { left = "16cell", right = "16cell", top = "3cell", bottom = "4cell" }

config.window_close_confirmation = "NeverPrompt"

return config
