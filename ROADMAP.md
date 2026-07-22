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

### Step 4: Keyboard & Window Management [IN PROGRESS]

**Key decision:** Abandoned Karabiner remapping. Native macOS shortcuts accepted (Cmd+C/V, etc.). Too many conflicts with Aerospace and app shortcuts. ZMK handles all custom key logic on the Sofle.

- [ ] Set input source to English — ABC (manual)
- [ ] Confirm ZMK Sofle pairing and normal HID behavior (manual)

**Window management (active):**

- [x] Aerospace installed from Nixpkgs (in `packages.nix`)
- [x] Config deployed: `aerospace.toml` via `home.file`
  - Alt for window management (focus, move, layout, close, launch — no conflicts)
  - Cmd for workspace switching (1-10) and move-to-workspace
  - Service mode for advanced ops (join-with, flatten, etc.)
- [ ] Grant Accessibility permission manually
- [ ] Test and verify keybindings
- [ ] Defer gaps, bars, rounded corners, complex rules

### Step 5: Launcher, Clipboard, Native Navigation [PLANNED]

- [ ] Raycast: Homebrew cask, manual account/launcher/extensions setup
- [ ] Maccy: Nixpkgs, Accessibility permission
- [ ] Test Raycast Clipboard History vs Maccy, keep one
- [ ] Trial Homerow (Homebrew cask) or Shortcat fallback
- [ ] Trial kindavim only after Karabiner, Aerospace, navigation are stable
- [ ] Defer SketchyBar until desktop tools and work apps are stable

### Step 6: Migrate Retained Arch Programs [PLANNED]

One `modules/home/<program>.nix` per retained program.

- Native Home Manager modules: Bat, Starship, Mise, Yazi, Taskwarrior
- Raw `xdg.configFile`/`home.file`: selected scripts, OpenCode, Television, Fastfetch, Hunk, JNV, Tabiew, JQP
- Adapt clipboard, browser, path assumptions for macOS
- Do not migrate: Hyprland, PipeWire, Fuzzel, SwayNC, Swappy, Linux browser flags

### Step 7: Secrets & Encryption [PLANNED]

- [ ] Add sops-nix + age after core config and before secret-backed apps
- [ ] Per-machine age identity outside Git, mode 0600
- [ ] SOPS ciphertext under `macos/secrets/`, public recipients in `.sops.yaml`
- [ ] Deploy secrets via sops-nix at runtime only
- [ ] Migrate: SSH, AI/API keys, Leetcode tokens
- [ ] Do not migrate shell history
- [ ] Keep Arch Transcrypt unchanged

### Step 8: Validate Bootstrap [PLANNED]

- [ ] Test `macos/setup/main.sh` from clean shell
- [ ] Test Lix-missing → first darwin-rebuild → repeat paths
- [ ] Confirm Nix packages, Homebrew casks, Home Manager config links, manual permissions
- [ ] Keep `mise run check macos`
- [ ] Add `darwin-rebuild check` when useful

### Step 9: Cleanup & Maintenance [PLANNED]

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
