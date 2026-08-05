# PLAN: Noctalia v5 desktop takeover (NixOS + Hyprland)

Goal: run Noctalia v5 as the shell for the Hyprland desktop, replacing
swaync / hypridle / hyprlock / hyprpaper / fuzzel / wlogout / cliphist / sunsetr.

Workflow: one step at a time. Apply each step with `nh os switch` (run in
`nixos/`), test manually, then come back. Agent must NOT run switch, must NOT
commit/stage. Only mark a step done after the user confirms it works.

## Resources (agent reference)

- Noctalia v5 docs (live): https://docs.noctalia.dev/v5/
- Noctalia docs source (cloned): `/tmp/opencode/noctalia-docs/src/content/docs/v5/`
  - Key files:
    - `getting-started/nixos.mdx` — flake input, home module, cachix
    - `compositor-settings/hyprland.mdx` — Lua bind syntax, blur, IPC keybinds
    - `configuration/index.mdx` — config layers, hot reload, validate
    - `configuration/shell.mdx` — shell/panel/launcher/OSD/lockscreen/keybinds/session
    - `getting-started/running-the-shell.mdx` — autostart methods
    - `bar/index.mdx`, `bar/widgets/index.mdx` — bar + widget list
    - `desktop/wallpaper.mdx` — wallpaper config
    - `services/idle.mdx`, `services/notifications.mdx`, `services/night-light.mdx`
    - `ipc/index.mdx` — `noctalia msg` command lists
- Noctalia repo (cloned): `/tmp/opencode/noctalia-src`
  - `nix/home-module.nix` — `programs.noctalia` module options
  - `nix/nixos-module.nix` — NixOS module + `recommendedServices`
  - `example.toml` — full reference config with defaults
- Noctalia cachix: https://app.cachix.org/cache/noctalia
- Nix option search: https://searchix.ovh/?query={KEYWORD}

## Decisions

- Config lives in `nixos/modules/noctalia/`, TOML format.
- `config.toml` symlinked via `config.lib.file.mkOutOfStoreSymlink` so inotify
  hot reload works without rebuild.
- Drop `programs.noctalia.settings` (home-module would write the same
  `~/.config/noctalia/config.toml` path — conflict with symlink).
- Keep `programs.noctalia.systemd.enable = true`. Service is lifecycle only
  (autostart + restart-on-crash); hot reload unaffected.
- Pin `github:noctalia-dev/noctalia/cachix`, drop `inputs.nixpkgs.follows`,
  add Cachix substituter (prebuilt binaries).
- Noctalia replaces: swaync, hypridle, hyprlock, hyprpaper, fuzzel, wlogout,
  cliphist, sunsetr.
- Unused modules stay on disk, only disabled in imports. Nothing deleted.
- Keep ly display manager (greeter deferred).
- Hyprland keybinds mostly set manually by user later; plan only swaps
  volume/brightness to `noctalia msg` IPC.
- No persistent workspaces. No app theming.
- Theme palette generated from wallpaper (`theme.source = "wallpaper"`).
- Simple idle/lock: lock 5min, screen-off 8min, suspend 10min.
- Bar / dock / launcher keep Noctalia defaults.

## Steps

- [ ] 0. Research complete: v5 docs read, current setup audited
- [ ] 1. `flake.nix`: noctalia input -> `cachix` branch, remove nixpkgs
      follows, add `nixConfig` cachix substituter, run
      `nix flake lock --update-input noctalia`
- [ ] 2. `configuration.nix`: add `services.upower.enable` and
      `services.power-profiles-daemon.enable` (battery + power widget)
- [ ] 3. `modules/noctalia/default.nix`: rewrite — drop `settings`, keep
      `enable` + `systemd.enable`, symlink `noctalia/config.toml` and
      `noctalia/walls` (reuse `hyprpaper/walls`)
- [ ] 4. `modules/noctalia/noctalia.toml`: new TOML — theme wallpaper,
      wallpaper dir/path, notification daemon, nightlight, location Paris,
      idle behaviors, `launch_apps_as_systemd_services`, telemetry off
- [ ] 5. `home.nix`: remove `./modules/hyprpaper` and `./modules/sunsetr`
      imports (disabled, not deleted)
- [ ] 6. `packages.nix`: remove `fuzzel`, `cliphist` (keep `wl-clipboard`)
- [ ] 7. `hyprland/lib/autostart.lua`: remove swaync / hypridle / cliphist
      spawns and their reload handlers
- [ ] 8. `hyprland/lib/keybinds.lua`: XF86 volume/brightness -> `noctalia msg`
      IPC (only this; rest manual)

## Manual, user later

Rebind to noctalia IPC once removed tools are gone:
- SUPER+D launcher -> `noctalia msg panel-toggle launcher`
- SUPER+V / SUPER+X clipboard -> `noctalia msg panel-toggle clipboard`
- SUPER+SHIFT+N swaync_picker -> drop (history lives in control center)
- SUPER+SHIFT+P wlogout -> `noctalia msg panel-toggle session`
- Optionally keep fuzzel installed until launcher rebind is tested.

## Verify after each step

- `nix flake check` (or `nh os switch` output)
- `noctalia config validate`
- `journalctl --user -u noctalia -b`
- IPC smoke: `noctalia msg panel-toggle launcher`
