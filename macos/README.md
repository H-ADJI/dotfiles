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
- Nix: Google Chrome and OpenCode

## Manual Steps

- Complete macOS setup assistant and system updates.
- Set input source to English - ABC.
- Grant requested accessibility, input monitoring, and screen-recording permissions after desktop tools are added.
- Keep company-managed software outside this configuration unless declarative management is explicitly allowed.

## Planned

- Add `sops-nix` + `age` after core configuration is stable, before SSH, AI, Leetcode, or other secret-backed tools.
- Keep Mac secrets under `macos/secrets/`; do not reuse Arch Transcrypt paths.
- Use per-machine `age` identities stored outside Git. Leave Arch Transcrypt unchanged until its own migration.
- Add Aerospace, Karabiner-Elements, Raycast, and Maccy after secrets handling is in place.

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
