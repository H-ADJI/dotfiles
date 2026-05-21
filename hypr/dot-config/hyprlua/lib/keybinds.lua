-- $mainMod = SUPER

-- $terminal = alacritty
-- $browser = google-chrome-stable
-- $fileManager = ghostty --env=EDITOR=nvim -e yazi
-- $wifi = ~/.config/scripts/classy_alacritty floatty impala
-- $bluetooth = ~/.config/scripts/classy_alacritty floatty bluetui
-- $wlogout = wlogout -b 4 -T 400 -B 400
-- $menu = fuzzel
-- $screen = ~/.config/scripts/hypr_screen
hl.bind("SUPER + B", hl.dsp.exec_cmd("google-chrome-stable "))
hl.bind("SUPER + D", hl.dsp.exec_cmd("fuzzel"))
hl.bind("SUPER + Q", hl.dsp.window.close("activewindow"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("alacritty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("ghostty --env=EDITOR=nvim -e yazi"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("wlogout"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("alacritty -e bluetui"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("alacritty -e impala"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("wayscriber --active"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client --hide-all"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("swaync-client -C"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("swaync-client -t"))
local cliphist_fuzzel_list = "cliphist list | fuzzel -d -w 90 -l 5 -p "
hl.bind(
	"SUPER + V",
	hl.dsp.exec_cmd(
		cliphist_fuzzel_list
			.. "Select an entry to copy it to your clipboard buffer:"
			.. " | cliphist decode"
			.. " | wl-copy"
	)
)
hl.bind(
	"SUPER + X",
	hl.dsp.exec_cmd(
		cliphist_fuzzel_list
			.. "Select an entry to delete it from cliphist:"
			.. "-t cc9393ff -S cc9393ff"
			.. " | cliphist delete"
	)
)
-- bind = , mouse:276, killactive
-- bind = , mouse:275, exec, $wlogout
-- bind = $mainMod SHIFT, F, togglefloating,
-- bind = $mainMod SHIFT, R, exec, hyprctl reload
-- bind = $mainMod, Z, exec, ~/.config/scripts/hypr_zoom
-- bind = $mainMod, KP_ADD, exec, ~/.config/scripts/hypr_zoom_scroll in
-- bind = $mainMod, minus, exec, ~/.config/scripts/hypr_zoom_scroll out
-- bind = $mainMod SHIFT, Z, exec, ~/.config/scripts/sway_zoom
-- bind = $mainMod, C, exec, $screen region
-- bind = $mainMod SHIFT, C, exec, $screen display
-- bind = $mainMod SHIFT, A, exec, ~/.config/scripts/emulator
-- bind = $mainMod SHIFT, D, exec, ~/.config/scripts/pkill
-- bind = $mainMod, f, fullscreen
-- bind = $mainMod, TAB, cyclenext
-- bind = $mainMod, S, togglespecialworkspace, magic
-- bind = $mainMod SHIFT, S, movetoworkspace, special:magic
-- bind = $mainMod SHIFT, X, exec, ~/.config/scripts/layout
-- bind = $mainMod, G, togglegroup
-- bind = $mainMod SHIFT, G, moveoutofgroup
-- bindd = $mainMod SHIFT, H, Move window to group on left, moveintogroup, l
-- bindd = $mainMod SHIFT, L, Move window to group on right, moveintogroup, r
-- bindd = $mainMod SHIFT, K, Move window to group on top, moveintogroup, u
-- bindd = $mainMod SHIFT, J, Move window to group on bottom, moveintogroup, d
-- bindd = $mainMod, n, Move grouped window focus right, changegroupactive, f
-- bindd = $mainMod, p, Move grouped window focus left, changegroupactive, b
-- bind = $mainMod, h, movefocus, l
-- bind = $mainMod, l, movefocus, r
-- bind = $mainMod, j, movefocus, d
-- bind = $mainMod, k, movefocus, u
-- bind = $mainMod SHIFT, H, movewindow, l
-- bind = $mainMod SHIFT, L, movewindow, r
-- bind = $mainMod SHIFT, K, movewindow, u
-- bind = $mainMod SHIFT, J, movewindow, d
-- bind = $mainMod, left, movefocus, l
-- bind = $mainMod, right, movefocus, r
-- bind = $mainMod, up, movefocus, u
-- bind = $mainMod, down, movefocus, d
-- bind = $mainMod, 1, workspace, 1
-- bind = $mainMod, 2, workspace, 2
-- bind = $mainMod, 3, workspace, 3
-- bind = $mainMod, 4, workspace, 4
-- bind = $mainMod, 5, workspace, 5
-- bind = $mainMod, 6, workspace, 6
-- bind = $mainMod, 7, workspace, 7
-- bind = $mainMod, 8, workspace, 8
-- bind = $mainMod, 9, workspace, 9
-- bind = $mainMod, 0, workspace, 10
-- bind = $mainMod SHIFT, 1, movetoworkspace, 1
-- bind = $mainMod SHIFT, 2, movetoworkspace, 2
-- bind = $mainMod SHIFT, 3, movetoworkspace, 3
-- bind = $mainMod SHIFT, 4, movetoworkspace, 4
-- bind = $mainMod SHIFT, 5, movetoworkspace, 5
-- bind = $mainMod SHIFT, 6, movetoworkspace, 6
-- bind = $mainMod SHIFT, 7, movetoworkspace, 7
-- bind = $mainMod SHIFT, 8, movetoworkspace, 8
-- bind = $mainMod SHIFT, 9, movetoworkspace, 9
-- bind = $mainMod SHIFT, 0, movetoworkspace, 10
-- bind = $mainMod, mouse_down, workspace, e+1
-- bind = $mainMod, mouse_up, workspace, e-1
-- bindm = $mainMod, mouse:272, movewindow
-- bindm = $mainMod, mouse:273, resizewindow
-- bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
-- bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-
-- bind = , XF86AudioRaiseVolume ,exec ,amixer -q -D pipewire sset Master 5%+
-- bind = ,XF86AudioLowerVolume, exec, amixer -q -D pipewire sset Master 5%-
-- bind = $mainMod, mouse_left, exec, amixer -q -D pipewire sset Master 5%+
-- bind = $mainMod, mouse_right, exec, amixer -q -D pipewire sset Master 5%-
-- bind = ,XF86AudioMute, exec, amixer -q -D pipewire sset Master toggle
-- bind = $mainMod,XF86AudioRaiseVolume, exec, amixer -q -D pipewire sset Capture 5%+
-- bind = $mainMod,XF86AudioLowerVolume, exec, amixer -q -D pipewire sset Capture 5%-
-- bind = $mainMod, XF86AudioMute, exec, amixer -q -D pipewire sset Capture toggle
-- bind = CTRL, XF86AudioNext, exec, playerctl position 5+
-- bind = CTRL, XF86AudioPrev, exec, playerctl position 5-
-- bind = , XF86AudioNext, exec, playerctl next
-- bind = , XF86AudioPrev, exec, playerctl previous
-- bind = , XF86AudioPause, exec, playerctl play-pause
-- bind = , XF86AudioPlay, exec, playerctl play-pause
-- $audio_switch_cmd= ~/.config/scripts/audio_picker
-- bind= $mainMod, i, exec, $audio_switch_cmd "source"
-- bind= $mainMod, o, exec, $audio_switch_cmd "sink"
