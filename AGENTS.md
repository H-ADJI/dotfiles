# Agent rules

- Manual steps should be documented in the readme files
- Prefer light weight, free, open source and simple tools.
- Eye candy is to be avoided, only add it if requested
- Stability+reproducibility is king
- Arch linux is configured using stow for dotfiles + a shell script
- Macos: using Nix (Lix) + Nix-darwin
- Never run `nh os switch`, `nixos-rebuild`, or any config apply yourself; the user applies changes manually.
- only do simple test no compilcated evaluations and tests
- Never stage or commit or edit git history

## Nix config checks (read-only, never apply)

Run after editing nix config. Evaluation only: no builds, no switch, no store changes.

- `nix flake check --no-build` — flake sanity + full NixOS eval (forces `nixosConfigurations.*.config.system.build.toplevel`, incl. home-manager). Does NOT check `darwinConfigurations` (Nix whitelists it as "known but unchecked").
- `nix eval --raw .#darwinConfigurations.macbook.system.outPath` — deep-evaluates the macOS config (forces the darwin toplevel incl. home-manager). Prints a store path on success.
