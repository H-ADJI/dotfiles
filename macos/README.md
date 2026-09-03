# Mac

**Nix-darwin** + **Home Manager** workstation configuration.

## Layout

The flake lives at the **repository root** (`~/PDE/flake.nix`) and builds both hosts:

- `common/` — home-manager modules shared by all hosts (zsh, tmux, nvim, git, ...)
- `macos/` — macOS host config + macOS-only modules (aerospace, colima, ...)
- `nixos/` — NixOS host config + NixOS-only modules (hyprland, noctalia, ...)

macOS-specific overrides of shared modules live next to the host config
(e.g. `macos/ghostty` overrides font size, window decoration and sets
`package = null` since the app comes from the homebrew cask).

## Bootstrap

No clone needed. Two commands:

```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake "github:hh9dj/PDE#macbook"
```

## Manual Steps (post-bootstrap)

### SSH keys

Place `~/.ssh/personal` and `~/.ssh/work` private keys from password manager.

```bash
chmod 600 ~/.ssh/personal ~/.ssh/work
```

### Night Shift

System Settings → Displays → Night Shift → set schedule (custom 22:00–07:00 or sunset-to-sunrise).

### System

- **Accessibility permission**: System Settings → Privacy & Security → Accessibility → grant to Aerospace, Ghostty
- **Menu bar**: System Settings → Control Center → "Automatically hide and show menu bar" → **Always** (SketchyBar replaces it)
- **Input sources**: Add **English - ABC**, **ABC Azerty** and **Unicode Hex Input** (System Settings → Keyboard → Input Sources)
- **Raycast hotkey**: Set alt-alt in Raycast Preferences → General → Hotkey (also disable Spotlight Cmd+Space)
- **OpenSuperWhisper** (Mac dictation): first launch → grant microphone permission + accessibility, download a model (Settings → Model), pick a global shortcut
- **Desktop widgets**: Right-click desktop → "Edit Widgets" → remove unwanted

## nh (Nix Helper)

```bash
nh darwin switch   # rebuild + activate, no args needed
nh darwin boot     # build now, activate at next login
nh darwin check    # verify the flake evaluates
```

- **Cleanup**: a daily launchd job runs `nh clean all --keep 3` (keeps the last 3 generations of user profiles and cleans the store). Manual equivalent: `nh clean all`
- **Note**: the flake is a git input — new/edited files must be committed before `nh darwin switch` picks them up

## SketchyBar

Managed by home-manager (`macos/sketchybar/`): package + launchd agent (RunAtLoad, KeepAlive) + config dir linked to `~/.config/sketchybar` (`config.source` + `recursive = true`).

- **Logs**: `~/Library/Logs/sketchybar/sketchybar.{out,err}.log`
- **Restart**: `launchctl kickstart -k gui/$UID/org.nix-community.home.sketchybar`
- Items (left to right): focused app name, centered date-time clock, then CPU, RAM, wifi (click to expand), bluetooth, battery
- Service PATH extras (`extraPackages`): `blueutil`. SketchyBar has no bluetooth event — bluetooth polls via `blueutil`
- The `sketchybarrc` **must stay executable** (`chmod +x`) — SketchyBar spawns it directly; if the bit is lost the bar renders empty

## Nix GC & Generations

- **Nix store**: cleanup runs daily via `nh clean all --keep 3` (`nh` module, launchd)
- **Boot entries**: automatic cleanup keeps last 10 system generations (`configuration.nix: system.activationScripts`)

Manual pruning:

```bash
sudo nix-env --delete-generations +10 -p /nix/var/nix/profiles/system
nix store gc
```
