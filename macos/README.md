# Mac

**Nix-darwin** + **Home Manager** workstation configuration.

## Bootstrap

No clone needed. Two commands:

```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install   # first time only
# restart terminal
sudo darwin-rebuild switch --flake github:hh9dj/dotfiles?dir=macos#macbook
```

Or use the setup script (same thing):

```bash
curl -sSfL https://raw.githubusercontent.com/hh9dj/dotfiles/main/macos/setup/main.sh | bash
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

| Layer                    | Tool                                            |
| ------------------------ | ----------------------------------------------- |
| System                   | nix-darwin                                      |
| User packages & dotfiles | Home Manager + `xdg.configFile`                 |
| Homebrew                 | nix-homebrew (casks: Ghostty, Raycast, Homerow) |
| Secrets                  | sops-nix + age (stored in `modules/secrets/`)   |

## Manual Steps (post-bootstrap)

- **Accessibility permission**: System Settings → Privacy & Security → Accessibility → grant to Aerospace, Ghostty
- **Input sources**: Add **English - ABC** and **ABC Azerty** (System Settings → Keyboard → Input Sources)
- **Raycast hotkey**: Set Cmd+Space in Raycast Preferences → General → Hotkey (also disable Spotlight Cmd+Space)
- **Desktop widgets**: Right-click desktop → "Edit Widgets" → remove unwanted
- **Clamshell (lid-closed) mode for desktop use**:
  1. System Settings → Displays → Advanced → enable **"Prevent automatic sleeping on power adapter when the display is off"**
  2. Alternatively: `sudo pmset -c sleep 0` (disables sleep on charger)
  3. Must be connected to a power adapter (clamshell only works while charging)

## Nix GC & Generations

- **Nix store**: GC runs weekly, deletes unreferenced paths older than 5 days (`darwin.nix: nix.gc`)
- **Boot entries**: automatic cleanup keeps last 10 system generations (`darwin.nix: system.activationScripts`)

Manual pruning:

```bash
sudo nix-env --delete-generations +10 -p /nix/var/nix/profiles/system
nix store gc
```
