local helpers = require("lib.helpers")
local vars = require("lib.vars")

-- 1. Windows
hl.bind("SUPER + Q", hl.dsp.window.close("activewindow"), { description = "Close active window" })
hl.bind("mouse:276", hl.dsp.window.close("activewindow"), { description = "Close active window" })

-- 2. Reload
hl.bind(
    "SUPER + SHIFT + R",
    hl.dsp.exec_cmd("hyprctl reload; notify-send -a 'Hyprland' 'Hyprland Reloaded'"),
    { description = "Reload Hyprland config" }
)

-- 3. Launchers
hl.bind("SUPER + D", hl.dsp.exec_cmd(vars.nctl .. "panel-toggle launcher"), { description = "Open app launcher" })
hl.bind("SUPER + X", hl.dsp.exec_cmd(vars.raffi .. "noctalia.yml"), { description = "Open raffi noctalia launcher" })
hl.bind("SUPER + T", hl.dsp.exec_cmd(vars.raffi .. "tuis.yml"), { description = "Open raffi TUI launcher" })
hl.bind("SUPER + SHIFT + TAB", hl.dsp.exec_cmd(vars.raffi .. "layouts.yml"), { description = "Open layout switcher" })
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(vars.terminal), { description = "Open terminal" })
hl.bind("SUPER + B", hl.dsp.exec_cmd(vars.browser), { description = "Open browser" })
hl.bind("SUPER + E", hl.dsp.exec_cmd(vars.file_picker), { description = "Open file picker" })
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd(vars.file_picker_alt), { description = "Open alternative file picker" })

-- 4. Session, screenshots, clipboard
local session_toggle = vars.nctl .. "panel-toggle session"
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd(session_toggle), { description = "Open session menu" })
hl.bind("mouse:275", hl.dsp.exec_cmd(session_toggle), { description = "Open session menu" })

hl.bind("SUPER + C", hl.dsp.exec_cmd(vars.nctl .. "screenshot-region"), { description = "Screenshot region" })
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd(vars.nctl .. "screenshot-fullscreen"), { locked = true, description = "Screenshot fullscreen" })
hl.bind("SUPER + V", hl.dsp.exec_cmd(vars.nctl .. "panel-toggle clipboard"), { description = "Open clipboard history" })

-- 5. Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(vars.nctl .. "volume-up"), { repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(vars.nctl .. "volume-down"), { repeating = true, description = "Volume down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(vars.nctl .. "volume-mute"), { locked = true, description = "Mute audio" })
hl.bind("SUPER + XF86AudioRaiseVolume", hl.dsp.exec_cmd(vars.nctl .. "mic-volume-up"), { repeating = true, description = "Mic volume up" })
hl.bind("SUPER + XF86AudioLowerVolume", hl.dsp.exec_cmd(vars.nctl .. "mic-volume-down"), { repeating = true, description = "Mic volume down" })
hl.bind("SUPER + XF86AudioMute", hl.dsp.exec_cmd(vars.nctl .. "mic-mute"), { locked = true, description = "Mute mic" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(vars.nctl .. "media toggle"), { locked = true, description = "Play/pause media" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(vars.nctl .. "media toggle"), { locked = true, description = "Play/pause media" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(vars.nctl .. "media next"), { locked = true, description = "Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(vars.nctl .. "media previous"), { locked = true, description = "Previous track" })
hl.bind("CTRL + XF86AudioNext", hl.dsp.exec_cmd("playerctl position 5+"), { repeating = true, description = "Seek forward 5 seconds" })
hl.bind("CTRL + XF86AudioPrev", hl.dsp.exec_cmd("playerctl position 5-"), { repeating = true, description = "Seek back 5 seconds" })

-- 6. Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(vars.nctl .. "brightness-up"), { repeating = true, description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(vars.nctl .. "brightness-down"), { repeating = true, description = "Brightness down" })

-- 7. Focus
hl.bind("ALT + TAB", hl.dsp.exec_cmd(vars.nctl .. "window-switcher"), { description = "Open window switcher" })
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })

-- 8. Workspaces
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }), { description = "Go to workspace 1" })
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }), { description = "Go to workspace 2" })
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }), { description = "Go to workspace 3" })
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }), { description = "Go to workspace 4" })
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }), { description = "Go to workspace 5" })
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }), { description = "Go to workspace 6" })
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }), { description = "Go to workspace 7" })
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }), { description = "Go to workspace 8" })
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }), { description = "Go to workspace 9" })
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }), { description = "Go to workspace 10" })
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("scratch"), { description = "Toggle magic workspace" })
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })

-- 9. Move windows
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }), { description = "Move window to workspace 1" })
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }), { description = "Move window to workspace 2" })
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }), { description = "Move window to workspace 3" })
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }), { description = "Move window to workspace 4" })
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }), { description = "Move window to workspace 5" })
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }), { description = "Move window to workspace 6" })
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }), { description = "Move window to workspace 7" })
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }), { description = "Move window to workspace 8" })
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }), { description = "Move window to workspace 9" })
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }), { description = "Move window to workspace 10" })
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratch" }), { description = "Move window to scratchpad" })
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l", group_aware = true }), { description = "Move window left" })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r", group_aware = true }), { description = "Move window right" })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u", group_aware = true }), { description = "Move window up" })
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d", group_aware = true }), { description = "Move window down" })

-- 10. Groups
hl.bind("SUPER + G", hl.dsp.group.toggle(), { description = "Toggle window group" })
hl.bind("SUPER + SHIFT + G", hl.dsp.window.move({ out_of_group = true }), { description = "Move window out of group" })
hl.bind("SUPER + N", hl.dsp.group.next(), { description = "Focus next group" })
hl.bind("SUPER + P", hl.dsp.group.prev(), { description = "Focus previous group" })

-- 11. Fullscreen and float
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Toggle fullscreen" })
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float(), { description = "Toggle floating window" })

-- 12. Resize
hl.bind("SUPER+ mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window by dragging" }) -- ALT + LMB: Move a window by dragging more than 10px.
hl.bind("SUPER + R", hl.dsp.submap(vars.submap.resize), { description = "Enter resize mode" })
hl.define_submap(vars.submap.resize, helpers.setup_resize_binds)

-- 13. Zoom
hl.bind("SUPER + Z", helpers.zoom, { description = "Zoom in" })
hl.bind("SUPER + KP_ADD", function()
    helpers.zoom(0.5)
end, { description = "Zoom in" })
hl.bind("SUPER + minus", function()
    helpers.zoom(-0.5)
end, { description = "Zoom out" })

-- 14. Layouts
helpers.setup_layout_binds()

-- 15. Transcribing
hl.bind("SUPER + O", helpers.start_transcribing, { description = "Start transcribing" })
hl.define_submap(vars.submap.transcribing, function()
    hl.bind("SUPER + O", helpers.stop_transcribing, { description = "Stop transcribing" })
    hl.bind("escape", helpers.stop_transcribing, { description = "Stop transcribing" })
end)
