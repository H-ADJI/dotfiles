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

## DeepSeek pricing tier indicator

Vendored locally (not npm) in `pi-agent/extensions/offpeak-deepseek/`, auto-discovered by pi like the `ask-user` extension. Shows the active DeepSeek peak/off-peak tier in the pi footer while a DeepSeek model is active.

Configuration lives in `pi-agent/agent/offpeak-deepseek.json`, symlinked to `~/.pi/agent/offpeak-deepseek.json` (same pattern as `zentui.json`): `peakWindowsUtc` (array of `[startHour, endHour)` UTC pairs, Mon-Fri only) and `labels` (what shows for peak vs off-peak). Edit that file when DeepSeek changes the schedule or you want different labels.
