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
  hot reload works without rebuild. Split by concern into `conf/*.toml`,
  entrypoint includes them with `[include] files = ["conf/"]`.
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
- Hyprland keybinds rebind to `noctalia msg` IPC (launcher, clipboard, session,
  control-center, screenshots, mic, media, window-switcher). Keep playerctl
  for seek binds only. Keep fuzzel installed for custom menus (no keybind).
- No persistent workspaces. No app theming.
- Theme palette generated from wallpaper (`theme.source = "wallpaper"`), light.
- Simple idle/lock: lock 5min, screen-off 8min, suspend 10min.
- Bar / dock / launcher keep Noctalia defaults.

## Steps

- [x] 0-8 + 4b. Noctalia shell setup complete: flake + cachix, upower/ppd,
      module + TOML config (split into `conf/`), imports cleaned, packages
      cleaned, autostart cleaned, XF86 volume/brightness -> noctalia IPC.
- [ ] 9. `hyprland/lib/keybinds.lua`: full rebind to noctalia IPC
      (launcher / clipboard / session / control-center audio+notifications /
      screenshots / mic / media / window-switcher). Drop dead binds
      (cliphist, wlogout, swaync_picker, hypr_screen, audio_picker).
      Keep TODO binds for unimplemented scripts. Keep playerctl for seek.
      Add `[shell.screenshot]` output policy to `conf/shell.toml`,
      remove `vars.launcher`, add `playerctl` package.
- [ ] 10. Cursor theme: Hyprland shows its built-in icon because no
      hyprcursor/XCursor theme is installed. Add `home.pointerCursor`
      (catppuccin-cursors.latteLight, 24, `enable = true`) in
      `modules/xdg/default.nix` (installs theme into
      `~/.local/share/icons/`, a hyprcursor search path). Select it via user
      session env vars in `modules/systemd.nix` (`HYPRCURSOR_THEME`,
      `HYPRCURSOR_SIZE`, plus `XCURSOR_THEME` fallback) — Hyprland picks these
      up because `systemd.variables = ["--all"]`. `cursor.default_theme_name`
      does not exist in Hyprland 0.56, so `modules/hyprland/lib/conf.lua` only
      sets `enable_hyprcursor = true`; `lib/env.lua` was removed (all vars
      migrated to systemd.nix). Verify with `hyprctl cursor` (no more Hyprland
      icon).
- [ ] 11. Shake-to-find cursor (macOS style): add `hypr-dynamic-cursors`
      plugin (`hyprland.plugins = [ pkgs.hyprlandPlugins.hypr-dynamic-cursors ]`
      in `modules/hyprland/default.nix`; HM generates `hl.plugin.load` for lua
      config). Configure in `modules/hyprland/lib/conf.lua` inside
      `if hl.plugin.dynamic_cursors` guard: `mode = "none"` (only shake-to-find,
      no tilt/rotate), default shake settings (threshold 6.0, base 4x, timeout
      2s), hyprcursor enabled for hi-res magnification (catppuccin theme is
      SVG-based). Verify: `hyprctl plugin list` shows dynamic-cursors loaded;
      shaking the mouse magnifies the cursor.

## Verify after each step

- `nix flake check` (or `nh os switch` output)
- `noctalia config validate`
- `journalctl --user -u noctalia -b`
- IPC smoke: `noctalia msg panel-toggle launcher`
- Cursor: `hyprctl cursor` shows the theme, not the Hyprland icon
