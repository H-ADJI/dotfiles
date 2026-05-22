require("lib")
-- TODO: fix wiki docs

hl.config({
	general = {
		gaps_in = 10,
		gaps_out = 30,
		border_size = 5,
		resize_on_border = true,
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
		--     col.border_active = rgba(333cffee) rgba(00ff99ee) 45deg
		--     col.border_inactive = rgba(595959aa)
		groupbar = {
			font_size = 12,
			-- font_family = "monospace",
			font_weight_active = "ultraheavy",
			font_weight_inactive = "normal",
			height = 30,
			indicator_height = 0,
			indicator_gap = 5,
			gaps_in = 5,
			gaps_out = 0,
			gradients = true,
			gradient_rounding = 10,
			gradient_round_only_edges = false,
			--         text_color = rgb(ffffff)
			--         text_color_inactive = rgba(ffffff90)
			--         col.active = rgba(00000040)
			--         col.inactive = rgba(00000020)
			--
		},
	},

	misc = {
		disable_hyprland_logo = true,
		force_default_wallpaper = 0,
	},
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
})
