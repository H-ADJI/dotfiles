# Rules

- Simple bootstrap setup for arch, nixos and macos workstations
- Manual steps should be documented in the readme files
- Prefer light weight, free, open source and simple tools.
- Eye candy is to be avoided, only add it if requested
- Stability+reproducibility is king
- Arch linux is configured using stow for dotfiles + a shell script
- Macos: using Nix (Lix) + Nix-darwin
- https://searchix.ovh/?query={KEYWORD} can be used to search for nix options
- If PLAN.md not empty at the repo root, follow it step by step.
- Implement PLAN.md one step at a time; never batch steps.
- Only mark a PLAN.md step done after the user confirms it was applied and works.
- Never run `nh os switch`, `nixos-rebuild`, or any config apply yourself; the user applies changes manually.
- Never stage or commit files unless explicitly asked.
