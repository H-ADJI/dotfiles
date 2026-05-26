hl.config({
    general = {
        gaps_in = 10,
        gaps_out = 10,
        border_size = 5,
        resize_on_border = true,
        ["col.active_border"] = "#000000",
        ["col.inactive_border"] = "#cdd6f4",
    },
    decoration = {
        rounding = 20,
        rounding_power = 8,
        active_opacity = 1.0,
        inactive_opacity = 0.9,
        shadow = { enabled = false },
        blur = { enabled = false },
    },
    binds = {
        drag_threshold = 10, -- Fire a drag event only after dragging for more than 10px
    },
    cursor = {
        inactive_timeout = 3,
        zoom_factor = 1,
    },
    group = {
        insert_after_current = false,
        group_on_movetoworkspace = true,
        ["col.border_active"] = "#000000",
        ["col.border_inactive"] = "#393939",
        groupbar = {
            font_size = 14,
            font_family = "JetBrains Mono, Noto Sans, sans-serif",
            font_weight_active = 1000,
            font_weight_inactive = 600,
            height = 30,
            indicator_height = 0,
            indicator_gap = 5,
            gaps_in = 5,
            gaps_out = 0,
            gradients = true,
            gradient_rounding = 10,
            gradient_round_only_edges = false,
            text_color = "#000000",
            text_color_inactive = "#FFFFFF",
            ["col.active"] = "#a6adc8",
            ["col.inactive"] = "#cdd6f4",
        },
    },

    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
        disable_autoreload = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
    animations = {
        enabled = true,
    },
})
