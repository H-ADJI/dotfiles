# Mac

**Nix-darwin** + **Home Manager** workstation configuration.

## Bootstrap

No clone needed. Two commands:

```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake "github:hh9dj/PDE#macbook"
```

Note: the flake is a git input — new/edited files must be committed before a switch picks them up.

## Manual Steps (post-bootstrap)

### SSH keys

Place `~/.ssh/personal` and `~/.ssh/work` private keys from password manager.

```bash
chmod 600 ~/.ssh/personal ~/.ssh/work
```

### Night Shift

System Settings → Displays → Night Shift → set schedule (custom 22:00–07:00 or sunset-to-sunrise).

### System

- **Accessibility permission**: System Settings → Privacy & Security → Accessibility → grant to Aerospace, Ghostty, Homerow
- **Menu bar**: System Settings → Control Center → "Automatically hide and show menu bar" → **Always** (SketchyBar replaces it)
- **Input sources**: Add **English - ABC**, **ABC Azerty** and **Unicode Hex Input** (System Settings → Keyboard → Input Sources)
- **Raycast hotkey**: Set alt-alt in Raycast Preferences → General → Hotkey
- **OpenSuperWhisper** (Mac dictation): first launch → grant microphone permission + accessibility, download a model (Settings → Model), pick a global shortcut
- **Desktop widgets**: Right-click desktop → "Edit Widgets" → remove unwanted

## Nix

Manual pruning:

```bash
sudo nix-env --delete-generations +10 -p /nix/var/nix/profiles/system
nix store gc
```
