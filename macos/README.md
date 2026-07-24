# macOS Setup

Nix-darwin + Home Manager workstation configuration for `khalils-MacBook-Pro`.

## Bootstrap

Clone repository, then run:

```bash
git clone git@github.com:H-ADJI/dotfiles.git ~/dotfiles
bash ~/dotfiles/macos/setup/main.sh
```

First run installs Lix when missing, then stops. Restart terminal and rerun script.

Manual rebuild:

```bash
sudo darwin-rebuild switch --flake ~/dotfiles/macos#khalils-MacBook-Pro
```

Static check:

```bash
mise run check macos
```

## Layout

- `hosts/khalils-MacBook-Pro/`: machine identity and imports.
- `modules/home/`: user packages and app configurations.

## Ownership

- Lix
- nix-darwin + Home Manager: system, user packages, and dotfiles
- nix-homebrew: Homebrew installation
- Homebrew cask: Ghostty
- Nix: Google Chrome, OpenCode, and Aerospace
- Home Manager `home.file`: Aerospace config (`aerospace.toml`)

## Manual Steps

### System
- Complete macOS setup assistant and system updates.
- Keep company-managed software outside this configuration unless declarative management is explicitly allowed.

### Input Settings
- Add keyboard input sources: **English - ABC** (US) and **ABC Azerty** (French)
  - System Settings > Keyboard > Text Input > Input Sources > Edit > Add
  - Toggle between layouts via Cmd+Space or Ctrl+Space (configure in Keyboard Shortcuts > Input Sources)
- Enable **Show Input menu in menu bar** for visual indicator (optional)

### Aerospace
Aerospace is installed from Nixpkgs and configured via `home.file` (see `modules/home/aerospace/`).

- On first launch, grant **Accessibility** permission in **System Settings > Privacy & Security > Accessibility**.
- Reload config after edits: `aerospace reload-config`
- Keybinding summary:
  - **Alt** (Option) + H/J/K/L — focus direction (no app conflicts)
  - **Alt + Shift + H/J/K/L** — move window
  - **Alt + 1-0** — switch workspace
  - **Alt + Shift + 1-0** — move window to workspace
  - **Alt + Space** — launch Ghostty
  - **Alt + B** — launch Chrome
  - **Alt + D** — launch Raycast
  - **Cmd + Space** — Raycast (set manually in Raycast Preferences > General > Hotkey)
  - **Alt + Q** — close focused window
  - **Alt + F** — fullscreen
  - **Alt + Tab** — workspace back-and-forth
  - **Alt + ;** — service mode (escape to exit)

## Planned

- Add `sops-nix` + `age` after core configuration is stable, before SSH, AI, Leetcode, or other secret-backed tools.
- Keep Mac secrets under `macos/secrets/`; do not reuse Arch Transcrypt paths.
- Use per-machine `age` identities stored outside Git. Leave Arch Transcrypt unchanged until its own migration.

## Nix GC & Generations

Automatic GC runs weekly (Sunday), deleting generations older than 30 days. Config in `darwin.nix: nix.gc`.

Manual generation pruning (keeps last 7):

```bash
sudo nix-env --delete-generations +7 -p /nix/var/nix/profiles/system
nix-env --delete-generations +7
nix store gc
```

## Rollback

## Verify

```bash
open -a Ghostty
opencode
```
