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
- **Input sources**: Add **English - ABC**, **ABC Azerty** and **Unicode Hex Input** (System Settings → Keyboard → Input Sources)
- **Raycast hotkey**: Set alt-alt in Raycast Preferences → General → Hotkey (also disable Spotlight Cmd+Space)
- **Desktop widgets**: Right-click desktop → "Edit Widgets" → remove unwanted

## nh (Nix Helper)

```bash
nh darwin switch   # rebuild + activate, no args needed
nh darwin boot     # build now, activate at next login
nh darwin check    # verify the flake evaluates
```

- **Cleanup**: a daily launchd job runs `nh clean all --keep 3` (keeps the last 3 generations of user profiles and cleans the store). Manual equivalent: `nh clean all`

## Nix GC & Generations

- **Nix store**: cleanup runs daily via `nh clean all --keep 3` (`nh` module, launchd)
- **Boot entries**: automatic cleanup keeps last 10 system generations (`configuration.nix: system.activationScripts`)

Manual pruning:

```bash
sudo nix-env --delete-generations +10 -p /nix/var/nix/profiles/system
nix store gc
```
