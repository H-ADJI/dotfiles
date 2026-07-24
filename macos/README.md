# macOS Setup

Nix-darwin + Home Manager workstation configuration.

## Bootstrap

```bash
git clone git@github.com:H-ADJI/dotfiles.git ~/dotfiles
bash ~/dotfiles/macos/setup/main.sh
```

First run installs Lix when missing, then stops. Restart terminal and rerun script.

Manual rebuild:

```bash
sudo darwin-rebuild switch --flake ~/dotfiles/macos#<hostname>
```

## Layout

```
macos/
├── flake.nix          # inputs + darwinConfigurations
├── darwin.nix         # system config (nix, defaults, brew)
├── home.nix           # user config (imports all modules)
├── modules/           # one file/dir per program
│   ├── aerospace/     # nix + toml (XDG: ~/.config/aerospace/)
│   ├── nvim/          # nix + init.lua, lua/ (XDG: ~/.config/nvim/)
│   ├── secrets/       # nix + secrets.yaml + .sops.yaml
│   ├── tmux/          # nix + sessions/ (XDG: ~/.config/tmuxp/)
│   ├── desktoppr/     # nix + wallpaper
│   ├── opencode.nix
│   ├── shell.nix
│   ├── ghostty.nix
│   ├── packages.nix
│   └── ...            # flat .nix files
├── setup/main.sh
└── flake.lock
```

## Ownership

| Layer | Tool |
|-------|------|
| System | nix-darwin |
| User packages & dotfiles | Home Manager + `xdg.configFile` |
| Homebrew | nix-homebrew (casks: Ghostty, Raycast, Homerow) |
| Secrets | sops-nix + age (stored in `modules/secrets/`) |

## Manual Steps (post-bootstrap)

- **Accessibility permission**: System Settings → Privacy & Security → Accessibility → grant to Aerospace, Ghostty
- **Input sources**: Add **English - ABC** and **ABC Azerty** (System Settings → Keyboard → Input Sources)
- **Raycast hotkey**: Set Cmd+Space in Raycast Preferences → General → Hotkey (also disable Spotlight Cmd+Space)
- **Desktop widgets**: Right-click desktop → "Edit Widgets" → remove unwanted
- **Clamshell mode**: Configure "Do not sleep when display is closed" for desktop use

## Keybindings

See `modules/aerospace/aerospace.toml` for the full config.

| Modifier | Scope |
|----------|-------|
| Alt (Option) | Aerospace window management (focus, move, resize, layout, launch) |
| Cmd | Native macOS shortcuts, Raycast launcher |
| ZMK (Sofle) | Custom layers, combos, tap-hold (on-keyboard, not in dotfiles) |

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
