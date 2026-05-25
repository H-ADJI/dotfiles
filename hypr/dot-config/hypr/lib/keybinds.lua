hl.bind("SUPER + Q", hl.dsp.window.close("activewindow"))
hl.bind("mouse:276", hl.dsp.window.close("activewindow"))
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

hl.bind("SUPER + B", hl.dsp.exec_cmd("google-chrome-stable "))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("alacritty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("ghostty --env=EDITOR=nvim -e yazi"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("ghostty --env=EDITOR=nvim -e walt"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("fuzzel"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("alacritty -e bluetui"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("alacritty -e impala"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("wayscriber --active"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client --hide-all"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("swaync-client -C"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("swaync-client -t"))

local wlogout = "wlogout -b 4 -T 400 -B 400"
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd(wlogout))
hl.bind("mouse:275", hl.dsp.exec_cmd(wlogout))

local home_dir = os.getenv("HOME")
local script_dir = home_dir .. "/.config/scripts/"

local hypr_screen = script_dir .. "hypr_screen "
hl.bind("SUPER + C", hl.dsp.exec_cmd(hypr_screen .. "region"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd(hypr_screen .. "display"))

local audio_picker = script_dir .. "audio_picker "
hl.bind("SUPER + I", hl.dsp.exec_cmd(audio_picker .. "source"))
hl.bind("SUPER + O", hl.dsp.exec_cmd(audio_picker .. "sink"))

local emulator_picker = script_dir .. "emulator"
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd(emulator_picker))

local pkill_picker = script_dir .. "pkill"
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd(pkill_picker))

local sink_volume = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%"
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(sink_volume .. "+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(sink_volume .. "-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

local source_volume = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%"
hl.bind("SUPER + XF86AudioRaiseVolume", hl.dsp.exec_cmd(source_volume .. "+"), { repeating = true })
hl.bind("SUPER + XF86AudioLowerVolume", hl.dsp.exec_cmd(source_volume .. "-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("CTRL + XF86AudioNext", hl.dsp.exec_cmd("playerctl position 5+"), { repeating = true })
hl.bind("CTRL + XF86AudioPrev", hl.dsp.exec_cmd("playerctl position 5-"), { repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { repeating = true })

local cliphist_fuzzel_list = "cliphist list | fuzzel -d -w 90 -l 5 -p "
hl.bind(
    "SUPER + V",
    hl.dsp.exec_cmd(cliphist_fuzzel_list .. "Select an entry to copy it to your clipboard buffer:" .. " | cliphist decode" .. " | wl-copy")
)
hl.bind(
    "SUPER + X",
    hl.dsp.exec_cmd(
        cliphist_fuzzel_list .. "Select an entry to delete it from cliphist:" .. "-t cc9393ff -S cc9393ff" .. " | cliphist delete"
    )
)

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + TAB", hl.dsp.window.cycle_next())

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

hl.define_submap("resize", function()
    local offset = 40
    hl.bind("L", hl.dsp.window.resize({ x = offset, y = 0, relative = true }), { repeating = true })
    hl.bind("H", hl.dsp.window.resize({ x = -offset, y = 0, relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0, y = offset, relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0, y = -offset, relative = true }), { repeating = true })

    -- Use `reset` to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.bind("SUPER + SHIFT + X", function()
    local workspace = hl.get_active_workspace().id
    local current_layout = hl.get_active_workspace().tiled_layout
    local layout
    if current_layout == "master" then
        layout = "scrolling"
    else
        layout = "master"
    end

    hl.workspace_rule({ workspace = tostring(workspace), layout = layout })
end)
