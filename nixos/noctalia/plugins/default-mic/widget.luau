-- Shows the default microphone name while the transcribing submap is active.
-- The transcribing submap is entered together with voxtype record toggle, so
-- it is a reliable proxy for "mic is being recorded".

local SUBMAP = "TRANSCRIBING"
local MIC_CMD =
    "pulsemixer --list-sources 2>/dev/null | grep ', Default' | sed -E 's/.*Name: (.*), Mute.*/\\1/'"

local currentSubmap = ""
local micName = ""

local function socketPath()
    local sig = noctalia.getenv("HYPRLAND_INSTANCE_SIGNATURE")
    local runtimeDir = noctalia.getenv("XDG_RUNTIME_DIR")
    if sig == nil or runtimeDir == nil then
        return nil
    end
    return runtimeDir .. "/hypr/" .. sig .. "/.socket2.sock"
end

-- runAsync callback is a result table in noctalia >= 5; tolerate a raw string.
local function trim(result)
    local value = result
    if type(result) == "table" then
        value = result.stdout
    end
    if value == nil then
        return ""
    end
    return noctalia.string.trim(tostring(value))
end

local function render()
    if currentSubmap == SUBMAP and micName ~= "" then
        barWidget.setGlyph("microphone")
        barWidget.setText(micName)
        barWidget.setVisible(true)
    else
        barWidget.setVisible(false)
    end
end

local function fetchMic()
    noctalia.runAsync(MIC_CMD, function(result)
        micName = trim(result)
        render()
    end)
end

local function onSubmap(name)
    currentSubmap = name
    if currentSubmap == SUBMAP then
        fetchMic()
    else
        render()
    end
end

local sock = socketPath()
if sock ~= nil then
    noctalia.runAsync("hyprctl submap", function(result)
        onSubmap(trim(result))
    end)
    noctalia.runStream("stdbuf -oL -eL socat -u UNIX-CONNECT:" .. sock .. " -", function(line)
        local match = line:match("submap>>(.*)")
        if match ~= nil then
            onSubmap(noctalia.string.trim(match))
        end
    end)
end

function update()
    render()
end
