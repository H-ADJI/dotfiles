---@param offset number
---@return nil
local function zoooooooooom(offset)
    local current_zoom_factor = hl.get_config("cursor.zoom_factor")
    if offset then
        current_zoom_factor = current_zoom_factor + offset
    elseif current_zoom_factor ~= 1 then
        current_zoom_factor = 1
    else
        current_zoom_factor = 2
    end

    if current_zoom_factor == 0 then
        current_zoom_factor = 1
    end

    hl.config({ cursor = { zoom_factor = current_zoom_factor } })
end

hl.bind("SUPER + Z", zoooooooooom)
hl.bind("SUPER + KP_ADD", function()
    zoooooooooom(0.5)
end)
hl.bind("SUPER + minus", function()
    zoooooooooom(-0.5)
end)

local home_dir = os.getenv("HOME")
local script_dir = home_dir .. "/.config/scripts/"
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd(script_dir .. "sway_zoom"))
