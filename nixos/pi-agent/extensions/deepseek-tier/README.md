# deepseek-tier

Standalone DeepSeek peak/off-peak pricing footer segment. Publishes a colored
footer status via `ctx.ui.setStatus()` so any footer owner (zentui, or pi's
native footer) renders it. No footer ownership conflict: `setStatus()` is keyed,
while `setFooter()` is global.

## Config

Optional `~/.pi/agent/deepseek-tier.json` (missing file → these defaults):

```json
{
  "enabled": true,
  "peakWindowsUtc": [
    [1, 4],
    [6, 10]
  ],
  "labels": { "peak": "peak pricing", "offPeak": "off-peak pricing" }
}
```

- `peakWindowsUtc`: `[startHour, endHour)` ranges in UTC, Mon–Fri. Weekends are
  always off-peak.
- Status shows only when the active model is a DeepSeek model (provider
  `deepseek` or `deepseek` in model id/name).
- Refreshed every 60s so hour-boundary changes apply without `/reload`.
- Peak = red, off-peak = black (own ANSI color in the published text).

## zentui integration

zentui strips status colors by default. Preserve the tier color:

```json
{
  "components": {
    "footer": {
      "styles": {
        "starship": {
          "extensionStatuses": {
            "colorModes": { "deepseekTier": "original" }
          }
        }
      }
    }
  }
}
```
