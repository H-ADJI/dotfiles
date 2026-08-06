local helpers = require("lib.helpers")
local vars = require("lib.vars")

local script_dir = vars.script_dir
local nctl = "noctalia msg "

hl.bind("SUPER + Q", hl.dsp.window.close("activewindow"))
hl.bind("mouse:276", hl.dsp.window.close("activewindow"))

hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload; notify-send -a 'Hyprland' 'Hyprland Reloaded'"))

hl.bind("SUPER + D", hl.dsp.exec_cmd(nctl .. "panel-toggle launcher"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(vars.terminal))
hl.bind("SUPER + B", hl.dsp.exec_cmd(vars.browser))

hl.bind("SUPER + E", hl.dsp.exec_cmd(vars.file_picker))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd(vars.file_picker_alt))

-- TODO: install / replace widgets and actions with a menu
hl.bind("SUPER + A", hl.dsp.exec_cmd("wayscriber --active"))
hl.bind("SUPER + W", hl.dsp.exec_cmd(vars.terminal_alt .. "-e walt"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(vars.terminal_alt .. "-e bluetui"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(vars.terminal_alt .. "-e impala"))
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd(nctl .. "panel-toggle control-center audio"))

hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd(nctl .. "panel-toggle control-center notifications"))

local session_toggle = nctl .. "panel-toggle session"
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd(session_toggle))
hl.bind("mouse:275", hl.dsp.exec_cmd(session_toggle))

hl.bind("SUPER + C", hl.dsp.exec_cmd(nctl .. "screenshot-region"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd(nctl .. "screenshot-fullscreen"), { locked = true })

hl.bind("SUPER + I", hl.dsp.exec_cmd(nctl .. "panel-toggle control-center audio"))
hl.bind("SUPER + O", hl.dsp.exec_cmd(nctl .. "panel-toggle control-center audio"))

-- TODO: script not implemented (sway_zoom; zoom also on SUPER+Z / KP_ADD / minus)
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd(script_dir .. "sway_zoom"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(nctl .. "volume-up"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(nctl .. "volume-down"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(nctl .. "volume-mute"), { locked = true })

hl.bind("SUPER + XF86AudioRaiseVolume", hl.dsp.exec_cmd(nctl .. "mic-volume-up"), { repeating = true })
hl.bind("SUPER + XF86AudioLowerVolume", hl.dsp.exec_cmd(nctl .. "mic-volume-down"), { repeating = true })
hl.bind("SUPER + XF86AudioMute", hl.dsp.exec_cmd(nctl .. "mic-mute"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(nctl .. "media toggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(nctl .. "media toggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(nctl .. "media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(nctl .. "media previous"), { locked = true })
hl.bind("CTRL + XF86AudioNext", hl.dsp.exec_cmd("playerctl position 5+"), { repeating = true })
hl.bind("CTRL + XF86AudioPrev", hl.dsp.exec_cmd("playerctl position 5-"), { repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(nctl .. "brightness-up"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(nctl .. "brightness-down"), { repeating = true })

hl.bind("SUPER + V", hl.dsp.exec_cmd(nctl .. "panel-toggle clipboard"))
hl.bind("ALT + TAB", hl.dsp.exec_cmd(nctl .. "window-switcher"))

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + TAB", hl.dsp.window.cycle_next({ tiled = false }))
hl.bind("SUPER + CTRL + TAB", hl.dsp.layout("cyclenext"))

hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l", group_aware = true }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r", group_aware = true }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u", group_aware = true }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d", group_aware = true }))

hl.bind("SUPER + G", hl.dsp.group.toggle())
hl.bind("SUPER + SHIFT + G", hl.dsp.window.move({ out_of_group = true }))
hl.bind("SUPER + N", hl.dsp.group.next())
hl.bind("SUPER + P", hl.dsp.group.prev())

hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float())

hl.bind("SUPER+ mouse:272", hl.dsp.window.drag(), { mouse = true }) -- ALT + LMB: Move a window by dragging more than 10px.
--
hl.bind("SUPER + R", hl.dsp.submap("resize"))

hl.define_submap("resize", helpers.setup_resize_binds)

hl.bind("SUPER + SHIFT + TAB", helpers.cycle_layout)

hl.bind("SUPER + Z", helpers.zoom)
hl.bind("SUPER + KP_ADD", function()
    helpers.zoom(0.5)
end)
hl.bind("SUPER + minus", function()
    helpers.zoom(-0.5)
end)

hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd(script_dir .. "sway_zoom"))
