# zentui (vendored minimal clone)

Trimmed fork of `pi-zentui@0.20.2`, vendored locally so the editor can be modified
in-repo. Only the features in `nixos/pi-agent/agent/zentui.json` are implemented —
everything else was deleted.

## Layout

- Loaded as a plain extension from `nixos/pi-agent/extensions/zentui/` (auto-discovered
  by pi, no package entry in `default.nix`).
- Config is read from `~/.pi/agent/zentui.json` (symlinked from
  `nixos/pi-agent/agent/zentui.json` by `default.nix`).
- Typecheck: `cd nixos/pi-agent && nix run nixpkgs#typescript -- --noEmit -p tsconfig.json`
  (after a rebuild regenerates `node_modules/pi-tsconfig`).

## Supported config entries

Everything below is read at session start. Anything not listed is ignored.

### `components.editor` (style: locked to `minimalist`)

| Key                               | Values                                 | Default           |
| --------------------------------- | -------------------------------------- | ----------------- |
| `viewportIndicators`              | boolean                                | `false`           |
| `styles.minimalist.pathDisplay`   | `"full"` \| `"compact"` \| `"project"` | `"full"`          |
| `styles.minimalist.contextFormat` | `"percent"` \| `"percent-total"`       | `"percent-total"` |

Locked (hardcoded defaults): `colorSource: "terminal"`, `showTimer: true`, `showCost: true`,
`showSessionName: true`, `showGit: true`, `contextGauge: false`,
`contextThresholds: {warning:70,error:90}`, `borderColorMode: "adaptive"`, `modelLabel: "id"`.

### `components.userMessages` (style: locked to `labeled`)

Nothing configurable — `colorSource: "terminal"` hardcoded.

### `components.selectorBorders` (style: locked to `zentui`)

Nothing configurable — `colorSource: "terminal"` hardcoded.

### `components.footer` (style: locked to `starship`)

| Key                                                  | Values                     | Default      |
| ---------------------------------------------------- | -------------------------- | ------------ |
| `styles.starship.segments.deepseekTier`              | boolean                    | `true`       |
| `styles.starship.extensionStatuses.colorModes.<key>` | `"zentui"` \| `"original"` | `"original"` |

Removed segments (no effect now): `cwd`, `sessionName`, `gitBranch`, `gitStatus`,
`gitMetrics`, `context`, `tokens`, `cost`, `sessionDuration`, `packageVersion`,
`modelInfo`, `time`, `runtime`, `gitCommit`.
Footer `colorSource: "terminal"` and separator `pipe` are hardcoded.

### `components.workingLine` (spinner: locked to `pinwheel`)

| Key              | Values  | Default |
| ---------------- | ------- | ------- |
| `enabled`        | boolean | `true`  |
| `textIntervalMs` | number  | `40`    |

Removed: `spinner` choice, custom messages, token/thought metrics, turn summary.

## DeepSeek peak/off-peak tier

Shown as a footer segment (`deepseekTier`) only while a DeepSeek model is active.
Off-peak renders black, peak renders red, prefixed with the whale icon: `🐋: off-peak`.

Top-level config (previously `offpeak-deepseek.json`, now merged into zentui.json):

| Key                           | Values                                            | Default             |
| ----------------------------- | ------------------------------------------------- | ------------------- |
| `deepseekTier.peakWindowsUtc` | `[startHour, endHour)` pairs in UTC, Mon–Fri only | `[[1, 4], [6, 10]]` |
| `deepseekTier.labels.peak`    | string                                            | `"peak pricing"`      |
| `deepseekTier.labels.offPeak` | string                                            | `"off-peak pricing"`  |

Weekends and hours outside the windows are off-peak.

## Turn cost in the editor

The minimalist editor's top-right cost label shows session cost plus the current
agent run's accumulated cost: `$1.234 +$0.056`.

- Reset on `agent_start`, accumulated on each `turn_end`
  (`event.message.usage.cost.total`).
- Implemented in `index.ts` (`runCost`, `getEditorCostLabel`).

## Hardcoded (not in zentui.json)

- Colors: terminal specs in `config.ts` `defaultColors`.
- Icons: none configurable (mode only, `auto`/`nerd`/`ascii` for the context gauge).

## Extending

- Add/change colors → `config.ts` `defaultColors` (or merge them in `mergeUserConfig`).
- Re-enable a deleted feature → recover from upstream `pi-zentui` and re-add to the
  relevant file; the wiring lives in `index.ts`.
