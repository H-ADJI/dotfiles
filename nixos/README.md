# NixOS

> if Arch and Debian had a baby it would be called NixOS

**Flakes** + **Home Manager** workstation configuration.

## Manual Steps

Add **flakes** + **nix-commands** experimental features into `/etc/nixos/configuration.nix`

```nix
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
```

Add user password

```bash
nixos-enter --root / -c 'passwd khalil'
```

Clone repo

```bash
git clone https://github.com/hh9dj/PDE
```

Copy hardware-config.nix

```bash
sudo cp /etc/nixos/hardware-configuration.nix ~/PDE/nixos/
```

Apply configuration

```bash
sudo nixos-rebuild switch --flake ~/PDE#nixos
```

## Layout

The flake lives at the **repository root** (`~/PDE/flake.nix`) and builds both hosts:

- `common/` — home-manager modules shared by all hosts (zsh, tmux, nvim, git, ...)
- `nixos/` — NixOS host config + NixOS-only modules (hyprland, noctalia, ...)
- `macos/` — macOS host config + macOS-only modules (aerospace, ...)

Host-specific overrides of shared modules live next to the host config (e.g.
`nixos/ghostty` adds ligature disabling, `macos/ghostty` overrides font size,
window decoration and sets `package = null` since the app comes from homebrew).
