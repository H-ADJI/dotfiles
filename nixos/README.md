# NixOS

> if Arch and Debian had a baby it would be called NixOS

**Flakes** + **Home Manager** workstation configuration.

## Manual Steps

Add **flakes** + **nix-commands** experimental features into `/etc/nixos/configuration.nix`

```nix
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
```
