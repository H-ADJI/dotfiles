# simpleTui

Minimal TUI extension — a trimmed, standalone fork of the vendored zentui, for easy
tweaking. Config lives in `~/.pi/agent/simpleTui.json` (symlinked from
`nixos/pi-agent/agent/simpleTui.json`).

## Enable / disable

Both simpleTui and zentui load; since both own the editor/footer they must not run
together. simpleTui no-ops when `"enabled": false`. To test simpleTui: set
`"enabled": true` and temporarily move `extensions/zentui/` out of the way (or delete it
after you confirm parity). Default is `false` so your current zentui keeps working.

## Config (`simpleTui.json`)

| Key | Values | Default |
|-----|--------|---------|
| `enabled` | boolean | `true` |
| `editor.viewportIndicators` | boolean | `false` |
| `editor.pathDisplay` | `"full"` \| `"compact"` \| `"project"` | `"full"` |
| `editor.contextFormat` | `"percent"` \| `"percent-total"` | `"percent-total"` |
| `workingLine.enabled` | boolean | `true` |
| `workingLine.messages` | string[] | `["Working"]` |
| `footer.deepseekTier.enabled` | boolean | `true` |
| `footer.deepseekTier.peakWindowsUtc` | `[startHour,endHour)` UTC Mon–Fri | `[[1,4],[6,10]]` |
| `footer.deepseekTier.labels.peak` | string | `"peak pricing"` |
| `footer.deepseekTier.labels.offPeak` | string | `"off-peak pricing"` |
| `footer.extensionStatuses.placements.<key>` | `"off"` \| `"left"` \| `"middle"` \| `"right"` | `"right"` |
| `footer.extensionStatuses.colorModes.<key>` | `"original"` \| `"zentui"` | `"original"` |

## Features

- **Editor (minimalist)**: terminal-bordered input frame; top-left timer + session name;
  top-right `$cost +$run` / model / thinking / context%; bottom-right cwd; adaptive border
  color by thinking level. No git branch.
- **User messages (labeled)**: `╭─ User ─╮` box, markdown-rendered.
- **Working line**: pinwheel spinner; working message picked randomly from
  `workingLine.messages` each turn (default `"Working"`).
- **Footer (right side)**: 🐋 deepseek peak/off-peak (peak red, off-peak black) + extension
  statuses (original color by default).
- **Selector borders**: model/settings selector top/bottom borders recolored.
- **Run cost**: sums `turn_end` cost; shown as `+$X.XXX` next to session cost.

## Hardcoded (not configurable)

All colors in `config.ts` `defaultColors`; pipe separator; deepseek tier on; statuses
original color; editor border adaptive.
