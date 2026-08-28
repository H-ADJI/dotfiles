# Deep trim: zentui → only what `nixos/pi-agent/agent/zentui.json` uses

DONE — all steps applied. Typecheck clean (`tsc --noEmit`).

Result: 15,488 → 3,567 lines, 33 → 20 files.

- editor: minimalist, terminal colors, full path, percent-total context, no viewport indicators (+ run cost appended to session cost)
- userMessages: labeled, terminal
- workingLine: pinwheel spinner via `setWorkingIndicator` (default messages)
- footer: starship — gitMetrics + sessionDuration + packageVersion + extensionStatuses only
- selectorBorders: terminal

Deleted (whole features): settings-command, settings-previews, interaction-summary,
footer-format, footer-layout, live-context, editor-transfer, editor-metadata-format (opencode
metadata renderer), telemetry, project-refresh, project-state, runtime, working-line-messages,
working-line-spinners.

Rewritten minimal: config.ts, index.ts, ui.ts, working-line.ts, footer.ts, state.ts,
format.ts, git.ts, package-version.ts, icons.ts.

Kept (feature implementations): minimalist-editor.ts, user-message*.ts,
prototype-patch-registry.ts, selector-border.ts, extension-status.ts, style.ts,
session-lifecycle.ts.
