# AGENTS.md — dotfiles

## Goals :

- multi-OS set-up for dev workstations.
- Using shell scripts for easy and quick setup.
- introduce Nix based approach for nixos and macos.

## Setup & Deployment

- current setup use init.sh as entrypoint for a single command setup for fresh arch linux machines.
- archinstall is called using config in ./archinstall/* using the following command:

```bash
  archinstall --config-url https://h-adji.github.io/dotfiles/archinstall/workstation.json
```

- setting up dotfiles by :

```bash
  curl -fsSL h-adji.github.io/dotfiles/init.sh | bash
```

- Encryption via `transcrypt` with argon2 password verification.
- Hash stored in `setup/lock.secure` (same value copied to `arch/setup/lib/dotfiles.sh`).
- Files matching patterns in `.gitattributes` are encrypted.
- stow is used to manage symlinks, .stow-local-ignore is the ignore list for stow.

## Dev and Test

- podman container for testing the changes
- using mise tasks for common commands and scripts:

```bash
    mise run build arch   # or "mise run build ." for root
    mise run test arch    # runs built container interactively
```

## Hardware

- current hardware is desktop workstation
