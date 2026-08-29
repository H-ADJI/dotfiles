local M = {}

M.home_dir = os.getenv("HOME")
M.browser = "brave"
M.terminal = "ghostty"
M.file_picker = M.terminal .. " -e yazi"
M.file_picker_alt = "nautilus"
M.nctl = "noctalia msg "
M.raffi = "raffi -c " .. M.home_dir .. "/.config/raffi/"
M.submap = {}
M.submap.resize = "RESIZE"
M.submap.transcribing = "TRANSCRIBING"

return M
