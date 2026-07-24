# ROADMAP — macOS and NixOS Dotfiles

## Status

| OS             | Status                                                   |
| -------------- | -------------------------------------------------------- |
| **Arch Linux** | Implemented in `arch/`                                   |
| **macOS**      | In progress — Step 4 of 9 (Keyboard & Window Management) |
| **NixOS**      | Planned — not started                                    |

## Core Decisions

- **No `shared/` directory.** Each OS owns its full config tree. Duplication is acceptable.
- Root-level shared files only: `README.md`, `AGENTS.md`, `ROADMAP.md`, `.gitattributes`, `.gitignore`, `mise.toml`, `init.sh`.
- **macOS:** nix-darwin + Home Manager. No stow. Home Manager owns user config through native modules, `home.file`, and `xdg.configFile`.
- **Packages:** Nix first. Homebrew (via nix-homebrew) only for macOS casks unavailable in Nixpkgs.
- **No key remapping layer.** Native macOS shortcuts accepted as-is (Cmd+C copy, Cmd+V paste, etc.). Aerospace uses Alt for window management (no conflicts) and Cmd for workspace switching. Decision made after Karabiner conflicts with Aerospace and app shortcuts proved unstable.

### Desktop Choices

| Role                    | Tool                               | Reasoning                                                     |
| ----------------------- | ---------------------------------- | ------------------------------------------------------------- |
| Window manager          | Aerospace                          | i3/Sway/Hyprland muscle memory, no SIP changes needed         |
| Launcher                | Raycast                            | Practical macOS replacement for fuzzel                        |
| Keyboard remapping      | None (native macOS)                | Karabiner conflicts with Aerospace and app shortcuts; native Cmd shortcuts accepted |
| Clipboard               | Maccy                              | Lightweight cliphist-style workflow                           |
| Browser Vim motions     | Vimium C                           | Keyboard-driven browser navigation                            |
| Native app keyboard nav | Homerow (Shortcat fallback)        | Vimium-like in native macOS apps                              |
| Modal editing           | kindavim (trial after base stable) | Modal editing in native text fields                           |
| Status bar              | SketchyBar (deferred)              | Waybar equivalent, adds config bulk                           |

Avoid: yabai, skhd, Rectangle/Loop, Alfred 5, Hammerspoon (defer until needed).

### Keyboard Responsibility Split

- **ZMK (Sofle split):** physical layout, layers, combos, tap-hold behavior. All custom key logic lives on the keyboard firmware.
- **nix-darwin:** system keyboard defaults (KeyRepeat, InitialKeyRepeat, ApplePressAndHoldEnabled, enableKeyMapping).
- **Aerospace:** window management with Alt modifier (no app shortcut conflicts). Cmd used only for workspace switching.
- **Input source:** English — ABC (neutral Latin, fewer dead-key surprises).
- **No key remapping layer** (Karabiner removed). Native macOS shortcuts (Cmd+C/V, etc.) accepted to avoid conflicts with Aerospace and apps.

---

## Phase 1: macOS Implementation

### Step 1: Editor Tools → Nix Packages [DONE]

- Keep raw Lua Neovim config under `macos/nvim/`.
- Replace Mason LSPs, formatters, linters, Tree-sitter parsers, Deno, build deps with Nix packages.
- Keep Mason only for tools unavailable in Nixpkgs.
- Test LSP startup, formatting, previews, snippets, parsers.
- Fix macOS browser commands in preview plugins.

### Step 2: Nixvim Evaluation [DONE]

- Translate stable plugins and core options first.
- Keep custom callbacks, snippets, queries, unsupported plugins as Lua escape hatches.
- Retain raw Lua config if full Nixvim increases maintenance or loses needed behavior.

### Step 3: Desktop Defaults [COMPLETED]

- [x] Dock: auto-hide, minimal behavior
- [x] Finder: show extensions, hidden files, path bar
- [x] Trackpad: tap-to-click, scroll behavior
- [x] Screenshots: PNG format, `~/Desktop/Screenshots`, no shadow — set via `darwin.nix`
- [x] Login/session behavior: guest disabled, no password hints, no fast user switching, shutdown visible, no auto-login

### Step 4: Keyboard & Window Management [COMPLETED]

**Key decision:** Abandoned Karabiner remapping. Native macOS shortcuts accepted (Cmd+C/V, etc.). Aerospace Alt bindings with no Cmd conflicts. ZMK handles all custom key logic on the Sofle.

**Done:** Aerospace (Nixpkgs, Alt bindings, gaps 30, service mode, mouse window-centering), jankyborders (12px square, black/Latte), Ghostty (block cursor, no blink, `shell-integration-features = no-cursor`), JetBrains Nerd Font installed via `nerd-fonts.jetbrains-mono`.

**Deferred (tracked in config TODOs):**
- `AppleCursorHiddenWhileTyping` — not working, revisit later (`darwin.nix`)
- Try without jankyborders — unnecessary eye candy, remove if unused

**Resolved:**
- `alt+q`: tested, no Ghostty conflict — removed binding, using native `Cmd+W`/`Cmd+Q` instead
- Wallpaper: set via `programs.desktoppr` with `coa_macos.png`
- Input source: documented in README manual steps

### Step 5: Launcher, Clipboard, Native Navigation [IN PROGRESS]

- [x] Raycast: Homebrew cask, sign in, set Cmd+Space hotkey, `alt-d` bound
- [x] Homerow: Homebrew cask, installed and working
- [ ] Maccy / clipcat: deferred — using Raycast clipboard history
- [ ] Experiment: replace Raycast with custom fzf/television script
      launcher, app/window switcher, clipboard management

### Step 6: Chrome Declarative Setup [PLANNED]

- [ ] Add `google-chrome` to Homebrew casks (already in `packages.nix` as nixpkgs)
- [ ] Extensions: declare via Nix (e.g. `chromium` Home Manager module or custom derivation)
- [ ] Colorscheme / theme: match Catppuccin Latte system-wide
- [ ] Settings, bookmarks, passwords strategy — decide Nix-managed vs manual

### Step 6b: PWA Auto-Install [PLANNED]

- [ ] No native Home Manager support for Chrome PWAs on macOS
- [ ] Activation method TBD after user research online
  - Candidates: manual Chrome GUI install, custom .app wrapper module, or alternative tooling
- [ ] PWAs to cover: Spotify, YouTube Music, Teams, Slack
- [ ] Implement chosen approach once researched

### Step 6c: Desktop Polish & Workflow Refinements [IN PROGRESS]

- [x] Resize mode: `alt-r` → H/J/K/L → Enter/Esc (tiled windows)
- [x] Smart resize: `alt-=` / `alt--` kept alongside
- [x] Screenshot tool: `screencapture` via Aerospace `alt-c` / `alt-shift-c`, opens in Preview with Markup toolbar (`Cmd+Shift+A`); format/location set via `darwin.nix`
- [x] Preview float rule via `on-window-detected`
- [ ] Display / clamshell mode notes in README (manual steps)

### Step 7: Migrate Retained Arch Programs [COMPLETED]

One `modules/home/<program>.nix` per retained program.

- [x] Bat — theme set to Catppuccin Latte via HM `config.theme`
- [x] Hunk — config.toml via `home.file`
- [x] Taskwarrior — HM module (dropped `include no-color.theme`, distro-specific path)
- [x] Fastfetch — HM module with full display config inlined (ANSI codes via `\x1b`)
- [x] Television — HM module with full TOML settings; `eval "$(tv init zsh)"` kept for full shell integration
- [x] OpenCode — HM module with full TUI keybinding config inlined
- [x] Yazi — HM module with settings + keymap (`wl-copy` → `pbcopy` for macOS)
- [x] Yazi theme — minimal Catppuccin Latte inline theme (no icon mappings, dropped `syntect_theme`)

- Native Home Manager modules: Bat, Starship, Mise, Yazi, Taskwarrior
- Raw `xdg.configFile`/`home.file`: selected scripts, OpenCode, Television, Fastfetch, Hunk, JNV, Tabiew, JQP
- Adapt clipboard, browser, path assumptions for macOS
- Do not migrate: Hyprland, PipeWire, Fuzzel, SwayNC, Swappy, Linux browser flags

### Step 8: Secrets & Encryption [COMPLETED]

- [x] Add `sops-nix` flake input + import darwin/HM modules
- [x] Generate age keypair (`age-keygen -o ~/.config/sops/age/keys.txt`)
- [x] Create `macos/secrets/.sops.yaml` with public key + creation rules
- [x] Create `macos/modules/home/secrets.nix` declaring secret targets
- [x] SSH private key deployed via sops-nix, GitHub auth verified
- [ ] Future: Save age keys to Bitwarden (manual user action)
- [ ] Future: Migrate AI/API keys, Leetcode tokens (not needed yet)

**Save age keys to Bitwarden:**
1. Copy public key from `~/.config/sops/age/keys.txt` (the `# public key: age1...` line)
2. Copy private key (entire file content between `# created:` and `# public key:`)
3. Create a secure note in Bitwarden named "SOPS Age Key" with both values
4. Also backup the `keys.txt` file itself as an attachment

**Rotating age keys (if compromised or periodically):**
1. Generate a new keypair: `age-keygen -o ~/.config/sops/age/keys.new.txt`
2. Extract the new public key from the output
3. Update `macos/secrets/.sops.yaml` — replace the `age` recipient with the new public key
4. Re-encrypt all secret files:
   ```
   SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops --rotate -i macos/secrets/secrets.yaml
   ```
   (uses the **old** key to decrypt, then encrypts with all keys in `.sops.yaml`)
5. Replace `keys.txt` with `keys.new.txt`
6. Rebuild to deploy updated secrets via sops-nix
7. Update the Bitwarden secure note with the new keypair
8. If the old key is still needed for history, add it as a second recipient in `.sops.yaml` before rotating

### Step 9: Validate Bootstrap [PLANNED]

- [ ] Test `macos/setup/main.sh` from clean shell
- [ ] Test Lix-missing → first darwin-rebuild → repeat paths
- [ ] Confirm Nix packages, Homebrew casks, Home Manager config links, manual permissions
- [ ] Keep `mise run check macos`
- [ ] Add `darwin-rebuild check` when useful

### Step 10: Cleanup & Maintenance [PLANNED]

- [ ] Remove unused `macos/zsh/`, `macos/ghostty/`, stale raw config trees after replacements verified
- [ ] Remove obsolete stow assumptions from macOS docs/scripts
- [ ] Review diff, run checks, commit only verified layers

### Step 11: Restructure macOS Nix Config [PLANNED]

Flatten `macos/modules/home/` → `macos/modules/`. Each module gets its own directory with `.nix` + config files side by side. Remove `dot-*` nesting, keep flat for easy navigation.

**Modules to colocate into directories:**

```
macos/modules/
├── aerospace/       keep     aerospace.nix + aerospace.toml
├── nvim/            move     macos/nvim/dot-config/nvim/  →  nvim/
├── tmux/            move     macos/tmux/dot-tmuxp/         →  tmux/
├── desktoppr/       move     assets/coa_macos.png          →  desktoppr/
├── television/      extract  inline ~130 lines → config.toml
├── opencode/        extract  inline ~166 lines → tui.json
├── yazi/            extract  inline ~128 lines → yazi/keymap/theme.toml
├── ghostty.nix      keep     inline-only
├── git.nix          keep     inline-only
├── shell.nix        keep     inline-only
├── fastfetch.nix    keep     inline-only
├── hunk.nix         keep     inline-only
├── taskwarrior.nix  keep     inline-only
├── colima.nix       keep     inline-only
├── jankyborders.nix keep     inline-only
└── packages.nix     keep     inline-only
```

**Remove after migration:**
- `macos/modules/home/` (flattened into `macos/modules/`)
- `macos/modules/home/assets/` (single asset moved to desktoppr/)
- `macos/nvim/` (config moved into modules/nvim/)
- `macos/tmux/` (config moved into modules/tmux/)

**Import changes in `home.nix`:**
Paths update from `../../modules/home/x.nix` to `../../modules/x/x.nix` (or `../../modules/x.nix` for flat files).

---



## Phase 2: NixOS [PLANNED]

Scaffold `nixos/` with flake, host config, Home Manager, system/home modules. Follow same structure as `macos/` but using NixOS-native configs. Do not start until macos foundation is stable.

---

## Phase 3: Repo Integration [PLANNED]

- [ ] Update `init.sh` dispatch for all three OS
- [ ] Update `mise.toml` with build/check tasks for NixOS
- [ ] Add SOPS recipient policy per OS
- [ ] Keep `.gitignore` root-level
- [ ] No shared dotfiles package
