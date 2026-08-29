# clipboard

Copies the final assistant response to the system clipboard automatically.

## How it works

Subscribes to pi's `agent_settled` event — fired once per prompt when the agent
is truly done (no retries, compaction retries, or queued follow-ups left). Takes
the last assistant message on the current branch and copies its text via pi's
own `copyToClipboard()` helper (the same one behind the built-in `/copy`
command; picks wl-copy/xclip/pbcopy or OSC 52 per environment).

Aborted/cancelled turns produce no copy (partial responses are skipped).

## Enable / disable

Config file: `~/.pi/agent/clipboard.json`

```json
{ "enabled": true }
```

- Missing/invalid file → enabled (default).
- Read fresh on every settle → editing the file takes effect without `/reload`.
- On NixOS the file is managed by `nixos/pi-agent/default.nix` — flip the
  `enabled` value there and rebuild.

## Manual steps

None. The extension is auto-discovered through the existing
`~/.pi/agent/extensions` symlink (`home-manager switch` / rebuild already
refreshes everything).