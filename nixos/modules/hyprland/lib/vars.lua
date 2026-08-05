local M = {}

M.home_dir = os.getenv("HOME")
M.script_dir = M.home_dir .. "/.config/hypr/scripts/"
M.browser = "brave"
M.terminal = "alacritty"
M.terminal_alt = "ghostty "
M.file_picker = M.terminal_alt .. "-e yazi"
M.file_picker_alt = "nautilus"

return M
