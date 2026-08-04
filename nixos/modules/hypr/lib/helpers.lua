local M = {}

local MAX_ZOOM = 3
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1.5

---@param offset number
---@return nil
function M.zoom(offset)
    local current = hl.get_config("cursor.zoom_factor")
    if offset ~= nil then
        current = current + offset
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    else
        current = ZOOM_TOGGLE_FACTOR
    end
    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end

function M.setup_resize_binds()
    local offset = 40
    hl.bind("L", hl.dsp.window.resize({ x = offset, y = 0, relative = true }), { repeating = true })
    hl.bind("H", hl.dsp.window.resize({ x = -offset, y = 0, relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0, y = offset, relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0, y = -offset, relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end

function M.cycle_layout()
    local layouts = { "scrolling", "dwindle", "master", "monocle" }
    local next_layout = "dwindle"

    local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
    if not workspace then
        return
    end
    local current_layout = workspace.tiled_layout

    for i = 1, #layouts do
        if layouts[i] == current_layout then
            local next_layout_idx = (i % #layouts) + 1
            next_layout = layouts[next_layout_idx]
            hl.exec_cmd(string.format("notify-send  -t 2000 -a 'Layout_Switcher' 'Layout: %s' ", next_layout))
            break
        end
    end

    hl.workspace_rule({ workspace = workspace.name, layout = next_layout })
end

return M
