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

### Step 3: Desktop Defaults [3 of 5 DONE]

- [x] Dock: auto-hide, minimal behavior
- [x] Finder: show extensions, hidden files, path bar
- [x] Trackpad: tap-to-click, scroll behavior
- [ ] Screenshots: location and format
- [ ] Login/session behavior

### Step 4: Keyboard & Window Management [COMPLETED]

**Key decision:** Abandoned Karabiner remapping. Native macOS shortcuts accepted (Cmd+C/V, etc.). Aerospace Alt bindings with no Cmd conflicts. ZMK handles all custom key logic on the Sofle.

**Done:** Aerospace (Nixpkgs, Alt bindings, gaps 30, service mode, mouse window-centering), jankyborders (12px square, black/Latte), Ghostty (block cursor, no blink, `shell-integration-features = no-cursor` to prevent shell override).

**Deferred (tracked in config TODOs):**
- `AppleCursorHiddenWhileTyping` — not working, revisit later (`darwin.nix`)
- `alt+q = close` — may conflict with Ghostty, test interaction (`aerospace.toml`)
- Input source → ABC + ABC Azerty — documented in README manual steps
- Wallpaper config — walt-like tool or nix-darwin native option
- Try without jankyborders — unnecessary eye candy, remove if unused

### Step 5: Launcher, Clipboard, Native Navigation [IN PROGRESS]

- [x] Raycast: Homebrew cask, sign in, set Cmd+Space hotkey
- [ ] Maccy / clipcat: deferred — both need clipboard daemon investigation
- [ ] Homerow: Homebrew cask, trial keyboard UI nav
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

### Step 6c: Desktop Polish & Workflow Refinements [PLANNED]

- [ ] Aerospace window rules via `on-window-detected`
  - Auto-float: System Settings, Raycast Preferences, Finder dialogs
  - Auto-assign apps to workspaces (Chrome → W, Ghostty → T, etc.)
- [ ] Resize mode: dedicated H/J/K/L bindings for width/height control
- [ ] Screenshot tool: configure macOS built-in (`screencapture`) or explore third-party
  - Set save location, format via `defaults write`
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

### Step 8: Secrets & Encryption [PLANNED]

- [ ] Add sops-nix + age after core config and before secret-backed apps
- [ ] Per-machine age identity outside Git, mode 0600
- [ ] SOPS ciphertext under `macos/secrets/`, public recipients in `.sops.yaml`
- [ ] Deploy secrets via sops-nix at runtime only
- [ ] Migrate: SSH, AI/API keys, Leetcode tokens
- [ ] Do not migrate shell history
- [ ] Keep Arch Transcrypt unchanged

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
