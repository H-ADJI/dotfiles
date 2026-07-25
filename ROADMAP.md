# ROADMAP

- [ ] AppleCursorHiddenWhileTyping — not working, revisit later (`darwin.nix`)
- [ ] Television `eval "$(tv init zsh)"` shell integration
- [x] OpenCode / other default options need to be removed from config
- [x] Tmux missing nix plugins / settings
- [x] Tmux replace fzf-session
- [x] Tmux replace float terminal
- [x] Nvim — vim.pack vs lazy.nvim
- [ ] Test methods for Macos
- [x] ZSH -- missing plugins / snippets
- [ ] Extract inline configs to a file for ease of modification and load them at runtime
- [ ] Migrate jnv — new `modules/jnv.nix` inlining 186-line TOML config from `arch/jnv/`
- [ ] Migrate jqp — new `modules/jqp.nix` inlining 2-line Catppuccin Latte theme config from `arch/jqp/`
- [ ] Migrate tabiew — new `modules/tabiew.nix` inlining 3-line TOML config from `arch/tabiew/`
- [ ] Migrate mise config — new `modules/mise.nix` porting settings from `arch/mise/config.toml`
- [ ] NixOS — scaffold `nixos/` with flake, host config, Home Manager, system/home modules (follow same structure as `macos/`)
- [ ] Update `init.sh` dispatch for all three OS
- [ ] Update `mise.toml` with build/check tasks for NixOS
- [ ] Keep `.gitignore` root-level
