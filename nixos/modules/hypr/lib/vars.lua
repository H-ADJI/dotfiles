local M = {}

M.home_dir = os.getenv("HOME")
M.script_dir = M.home_dir .. "/.config/hypr/scripts/"
M.browser = "google-chrome-stable"
M.terminal = "alacritty"
M.terminal_alt = "ghostty"
M.file_picker = "yazi"
M.file_picker_alt = "thunar"
M.launcher = "fuzzel"

return M
