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
- Homebrew cask: Ghostty and Karabiner-Elements
- Nix: Google Chrome and OpenCode
- Home Manager `home.file`: Karabiner-Elements config (pc-style shortcuts)

## Manual Steps

### System
- Complete macOS setup assistant and system updates.
- Keep company-managed software outside this configuration unless declarative management is explicitly allowed.

### Input Settings
- Set input source to **English - ABC** (System Settings > Keyboard > Text Input > Input Sources).

### Karabiner-Elements
Karabiner is installed via Homebrew cask and configured via `home.file` (see `modules/home/karabiner/`). Manual permissions required:

1. **Open Karabiner-Elements.app** from `/Applications` and complete its initial setup prompts.
2. **Approve DriverKit extension** in **System Settings > General > Login Items & Extensions > Driver Extensions**.
3. **Enable Input Monitoring** in **System Settings > Privacy & Security > Input Monitoring**:
   - Click **+** → press `Cmd+Shift+G` → type `/Applications/Karabiner-Elements.app` → **Open**
   - Toggle the switch **ON** (if already listed, toggle OFF and ON again)
4. **Enable Accessibility** in **System Settings > Privacy & Security > Accessibility** (same process).
5. **Verify** all services are running:

   ```bash
   pgrep -fl karabiner
   ```

   Expect: `karabiner_grabber`, `karabiner_observer`, `karabiner_console_user_server`.

   If only `karabiner_console_user_server` shows, Input Monitoring permission is still missing.

6. **Test shortcuts:**
   - Chrome: `Ctrl+C` copies, `Ctrl+V` pastes (should work like Linux)
   - Ghostty: `Ctrl+C` sends SIGINT (unchanged)
   - To force-reload config after edits: `Karabiner-Elements.app > Menu > Reload` or restart the app.

### Other Desktop Tools
- Grant accessibility, input monitoring, and screen-recording permissions as prompted when Aerospace, Raycast, Maccy, etc. are added later.

## Planned

- Add `sops-nix` + `age` after core configuration is stable, before SSH, AI, Leetcode, or other secret-backed tools.
- Keep Mac secrets under `macos/secrets/`; do not reuse Arch Transcrypt paths.
- Use per-machine `age` identities stored outside Git. Leave Arch Transcrypt unchanged until its own migration.

## Rollback

List generations:

```bash
darwin-rebuild --list-generations
```

Switch to previous generation:

```bash
sudo darwin-rebuild switch --rollback
```

## Verify

```bash
open -a Ghostty
opencode
```
