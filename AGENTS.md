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
