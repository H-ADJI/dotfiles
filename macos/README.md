# Mac

**Nix-darwin** + **Home Manager** workstation configuration.

## Bootstrap

No clone needed. Two commands:

```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake github:hh9dj/PDE?dir=macos#macbook
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
