# AGENTS

## Setup

- multi-OS set-up for dev workstations.
- Using shell scripts for easy and quick setup.
- introduce Nix based approach for nixos and macos.
- Encryption via `transcrypt` with argon2 password verification.
- Files matching patterns in `.gitattributes` are encrypted.
- stow is used to manage symlinks, .stow-local-ignore is the ignore list for stow.

## Test

- podman container for testing the changes
- using mise tasks for common commands and scripts:

```bash
    mise run build arch   # or "mise run build ." for root
    mise run test arch    # runs built container interactively
```

- agents should not run the test command since they take too long
