local M = {}

local vars = require("lib.vars")

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

function M.start_transcribing()
    hl.exec_cmd("voxtype record toggle")
    hl.dispatch(hl.dsp.submap(vars.submap.transcribing))
end

function M.stop_transcribing()
    hl.exec_cmd("voxtype record toggle")
    hl.dispatch(hl.dsp.submap("reset"))
end

local layout_overrides = {
    ["SUPER + TAB"] = {
        default = {
            action = hl.dsp.window.cycle_next({ tiled = false }),
            opts = { description = "Cycle through floating windows" },
        },
        monocle = {
            action = hl.dsp.layout("cyclenext"),
            opts = { description = "Cycle workspaces" },
        },
    },
}

local layout_bind_state = {}

local function current_layout()
    local ws = hl.get_active_workspace()
    return ws and ws.tiled_layout or "default"
end

local function update_layout_binds()
    local layout = current_layout()
    for key, variants in pairs(layout_overrides) do
        local want = variants[layout] and layout or "default"
        if layout_bind_state[key] ~= want then
            hl.unbind(key)
            local v = variants[want]
            hl.bind(key, v.action, v.opts)
            layout_bind_state[key] = want
        end
    end
end

function M.setup_layout_binds()
    for key, variants in pairs(layout_overrides) do
        local v = variants.default
        hl.bind(key, v.action, v.opts)
        layout_bind_state[key] = "default"
    end
    hl.on("workspace.active", update_layout_binds)
    hl.on("config.props_refreshed", update_layout_binds)
    update_layout_binds()
end

return M
