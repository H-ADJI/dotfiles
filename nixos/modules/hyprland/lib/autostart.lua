hl.on("hyprland.start", function()
    -- TODO: migrate to systemd services
end)

hl.on("config.reloaded", function()
    -- hl.exec_cmd("$HOME/.config/hypr/scripts/wellbeing --restart")
    -- hl.exec_cmd("sleep 3; bluetoothctl connect 10:94:97:36:C7:15")
end)
