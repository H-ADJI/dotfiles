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
sudo nixos-rebuild switch --flake ~/PDE/nixos#nixos
```
