hl.window_rule({
    name = "custom.floatty",
    match = { class = "custom.floatty" },
    float = true,
    center = true,
    size = { "monitor_w * 0.8", "monitor_h * 0.8" },
})
hl.window_rule({
    name = "image viewer",
    match = { class = "imv" },
    float = true,
    center = true,
    size = { "monitor_w * 0.8", "monitor_h * 0.8" },
})
hl.window_rule({
    name = "terminal img preview ueberzug",
    match = { class = "ueberzugpp.+" },
    float = true,
    no_initial_focus = true,
    no_focus = true,
    border_size = 0,
    no_anim = false,
})
hl.window_rule({
    name = "showmethekey",
    match = { title = "Floating Window - Show Me The Key" },
    float = true,
    no_initial_focus = true,
    no_focus = true,
    pin = true,
    border_size = 0,
    no_anim = false,
    size = { "monitor_w * 0.2", "monitor_h * 0.1" },
    move = { "monitor_w * 0.8", "monitor_h * 0.9" },
})
hl.window_rule({
    name = "screenshare_indicator",
    match = { title = ".+ is sharing .+" },
    float = true,
    no_initial_focus = true,
    no_focus = false,
    pin = true,
    border_size = 0,
    no_anim = false,
    size = { "monitor_w / 5", "monitor_h / 30" },
    move = { "monitor_w / 2 - monitor_w / 10", "monitor_h - monitor_h / 30" },
})
hl.workspace_rule({ workspace = "s[true]", gaps_out = 80 })

hl.window_rule({ name = "floating windows", match = { float = true }, workspace = "unset" })
hl.window_rule({ name = "screen sharing picker", match = { class = "hyprland-share-picker" }, workspace = "unset", float = true })
