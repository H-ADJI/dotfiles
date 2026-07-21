# ROADMAP — macOS and NixOS Dotfiles

## Status

- **Arch Linux** — implemented in `arch/`
- **macOS** — foundation implemented; desktop, editor, secrets, and migration planned
- **NixOS** — planned

---

## Core Decision

No `shared/` dotfiles directory.

Each OS owns its full dotfiles tree, setup logic, packages, and platform-specific choices. Duplication is acceptable and preferred over cross-OS coupling.

```text
dotfiles/
├── arch/    # full Arch setup + dotfiles
├── macos/   # full macOS setup + dotfiles
└── nixos/   # full NixOS setup + dotfiles
```

Only root-level repo metadata stays shared:

- `README.md`
- `AGENTS.md`
- `ROADMAP.md`
- `.gitattributes`
- `.gitignore`
- `mise.toml`
- `init.sh`

Design rule: if macOS and Arch both need `zsh`, `nvim`, `git`, or `starship`, each OS gets its own copy under its own directory. Keep each OS independently understandable and deployable.

---

## Phase 1: macOS Support

Goal: introduce `macos/` as a complete standalone macOS workstation setup.

### Current Structure

Implemented:

```text
macos/
├── flake.nix
├── flake.lock
├── hosts/
│   └── khalils-MacBook-Pro/
│       ├── darwin.nix
│       └── home.nix
├── modules/
│   └── home/
│       ├── files.nix
│       ├── ghostty.nix
│       ├── git.nix
│       ├── packages.nix
│       ├── shell.nix
│       └── tmux.nix
├── setup/
│   └── main.sh
├── nvim/
├── tmux/
└── README.md
```

Each OS owns its config. Copy/adapt from `arch/` only when useful. Do not add a shared dotfiles directory.

### Setup

1. Detect macOS in `init.sh` and dispatch to `macos/setup/main.sh`.
2. Bootstrap Lix on macOS.
3. Use nix-darwin + Home Manager.
   - Keep structure simple at first.
   - Prefer one host config before introducing reusable modules.
   - Add abstractions only when duplication becomes painful.
4. Manage user packages and program config through Home Manager.
5. Use Nix packages first. Use nix-homebrew only for unavailable macOS apps.
6. Configure macOS defaults:
   - Dock
   - Finder
   - keyboard repeat
   - trackpad
   - screenshots
   - login/session behavior
7. Use Aerospace as the window manager.
8. Use Raycast as the launcher and command palette.
9. Use Karabiner-Elements for keyboard remapping.
10. Use Maccy for clipboard history.
11. Keep browser Vim motions with Vimium C.
12. Evaluate Homerow first for keyboard-driven native app navigation.
    - Shortcat is fallback if Homerow does not fit.
13. Evaluate kindavim later for modal editing in native text fields.
14. Defer SketchyBar until the base macOS desktop is stable.

### Current Foundation

Implemented and verified in small layers:

1. Lix, nix-darwin, Home Manager, and nix-homebrew flake inputs.
2. One Apple Silicon host: `khalils-MacBook-Pro`.
3. Nix-darwin: Lix, Homebrew installation ownership, Ghostty cask, keyboard repeat defaults.
4. Home Manager: user packages, Git/Delta, Zsh, Tmux/Tmuxp, Ghostty config, and raw Neovim Lua config.
5. Nix packages: Google Chrome, OpenCode, CLI tools, runtimes, and editor dependencies.
6. `macos/setup/main.sh`: Lix bootstrap and nix-darwin rebuild only. It does not install apps imperatively.
7. Static check: `mise run check macos`.

Bootstrap from a cloned repository:

```bash
bash ~/dotfiles/macos/setup/main.sh
```

First run installs Lix when absent, then stops. Restart terminal and rerun. Later runs use:

```bash
sudo darwin-rebuild switch --flake ~/dotfiles/macos#khalils-MacBook-Pro
```

Do not use Stow for macOS. Home Manager owns user config through native modules, `home.file`, and `xdg.configFile`.

### Remaining Build Sequence

Build and verify each layer before continuing.

#### Step 1: Editor Tools Before Nixvim

1. Keep current raw Lua Neovim config under `macos/nvim/`.
2. Replace Mason-managed LSPs, formatters, linters, Tree-sitter parsers, Deno, and build dependencies with Nix packages where available.
3. Keep Mason only for tools unavailable in Nixpkgs.
4. Test LSP startup, formatting, previews, snippets, and parsers on macOS.
5. Fix macOS browser commands in preview plugins.

#### Step 2: Incremental Nixvim Evaluation

1. Add Nixvim only after external editor tools are declarative.
2. Translate stable plugins and core options first.
3. Keep custom callbacks, snippets, queries, and unsupported plugins as Lua escape hatches.
4. Treat the Nixvim migration as a controlled plugin-version upgrade from `lazy-lock.json` to flake-pinned versions.
5. Retain raw Lua config if full Nixvim increases maintenance or loses needed behavior.

#### Step 3: Minimal Desktop Defaults

Add and verify small groups of nix-darwin defaults:

1. Dock: auto-hide and minimal behavior.
2. Finder: show extensions, hidden files, and path bar.
3. Trackpad: tap-to-click and chosen scroll behavior.
4. Screenshots: location and format.
5. Login/session behavior.

Keep desktop settings low-distraction and Linux-like. Do not add cosmetic tuning.

#### Step 4: Keyboard and Window Management

1. Set macOS input source to **English - ABC**.
2. Confirm ZMK keyboard pairing and normal HID behavior.
3. Add Karabiner-Elements through Homebrew cask.
4. Add only macOS-specific modifier normalization, laptop fallback, and app exceptions.
5. Do not duplicate ZMK layers, combos, or tap-hold logic in Karabiner.
6. Grant Input Monitoring, Accessibility, and DriverKit permissions manually.
7. Add Aerospace from Nixpkgs and deploy raw `aerospace.toml` through Home Manager.
8. Start Aerospace with focus/move directions, workspaces 1–3, window moves, terminal/browser launch, and simple communication rules.
9. Grant Accessibility manually. Defer gaps, bars, rounded corners, and complex rules.

#### Step 5: Launcher, Clipboard, and Native Navigation

1. Add Raycast through Homebrew cask. Configure account, launcher hotkey, and extensions manually.
2. Add Maccy from Nixpkgs. Grant Accessibility manually.
3. Test Raycast Clipboard History and Maccy. Keep one clipboard history workflow.
4. Trial Homerow from Homebrew cask. Use Shortcat only if Homerow fails daily use.
5. Trial kindavim only after Karabiner, Aerospace, and native navigation are stable.
6. Do not add SketchyBar until desktop tools and work apps are stable.

#### Step 6: Migrate Retained Arch Programs

Use one `modules/home/<program>.nix` file per retained program.

1. Native Home Manager modules: Bat config, Starship config, Mise, Yazi, Taskwarrior.
2. Raw `xdg.configFile` or `home.file`: selected scripts, OpenCode, Television, Fastfetch, Hunk, JNV, Tabiew, JQP.
3. Port scripts selectively; adapt clipboard, browser, and path assumptions for macOS.
4. Do not migrate Hyprland, PipeWire, Fuzzel, SwayNC, Swappy, Linux browser flags, or other Linux-only desktop tooling.

#### Step 7: Secrets and Encryption

1. Add `sops-nix` and `age` after core config and before secret-backed apps.
2. Generate a per-machine `age` identity outside Git with mode `0600`.
3. Store only SOPS ciphertext under `macos/secrets/` and public recipients in `.sops.yaml`.
4. Deploy secrets at runtime through `sops-nix`; never use Nix text/source helpers with plaintext secrets.
5. Migrate Mac SSH, AI/API, and Leetcode secrets one at a time.
6. Do not migrate shell history.
7. Keep Arch Transcrypt unchanged until an independent Arch migration is proven.

#### Step 8: Validate Bootstrap

1. Test `macos/setup/main.sh` from a clean shell.
2. Test Lix-missing, first nix-darwin, and repeat `darwin-rebuild` paths.
3. Confirm Nix packages, Homebrew Ghostty, Home Manager config links, and required manual permissions.
4. Keep `mise run check macos`.
5. Add and validate `darwin-rebuild check --flake ./macos#khalils-MacBook-Pro` when useful.

#### Step 9: Cleanup and Maintenance

1. Remove unused `macos/zsh/`, `macos/ghostty/`, and stale raw configuration trees after replacements are verified.
2. Keep Darwin config together in host `darwin.nix`; split Home Manager config by program under `modules/home/`.
3. Remove obsolete Stow assumptions from macOS documentation and scripts.
4. Review diff, run checks, and commit only verified layers.

### Desktop Choices

Primary choices:

- **Window manager:** Aerospace
- **Launcher / command palette:** Raycast
- **Keyboard remapping:** Karabiner-Elements
- **Clipboard manager:** Maccy
- **Browser Vim motions:** Vimium C
- **Native app keyboard navigation:** Homerow first, Shortcat fallback
- **Modal editing:** kindavim trial after base setup
- **Status bar:** SketchyBar later

Reasoning:

- Aerospace maps best to i3/Sway/Hyprland muscle memory and avoids SIP-heavy setup.
- Raycast is the practical macOS replacement for fuzzel.
- Karabiner is important because the main keyboard is a custom Sofle/ZMK split keyboard.
- Maccy gives a lightweight `cliphist`-style workflow.
- Homerow/Shortcat cover Vimium-like keyboard navigation in native macOS apps.
- kindavim is useful but should be tested after core desktop behavior is stable.
- SketchyBar is the Waybar equivalent but should wait because it adds config bulk.

Avoid for initial setup:

- yabai — powerful but riskier on company macOS because advanced features can require SIP changes.
- skhd — mostly redundant while using Aerospace keybinds.
- Rectangle / Loop — redundant with Aerospace.
- Alfred 5 — Raycast alternative; do not run both initially.
- Hammerspoon — defer until a concrete automation gap exists.

### Keyboard Setup

Primary keyboard is a custom Sofle split wireless keyboard running ZMK.

Use macOS input source:

- **ABC**

Reasoning:

- ZMK should own the custom physical layout and layers.
- macOS should receive final normal HID keycodes.
- `ABC` is a neutral Latin input source with fewer dead-key surprises.
- Avoid region-specific layouts unless ZMK intentionally depends on them.

Responsibilities:

- **ZMK:** real custom layout, layers, combos, tap-hold behavior.
- **Karabiner-Elements:** macOS-specific remaps, modifier normalization, laptop keyboard fallback, app-specific exceptions.
- **nix-darwin:** system keyboard defaults.

Suggested nix-darwin defaults:

```nix
system.defaults.NSGlobalDomain.KeyRepeat = 2;
system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
system.keyboard.enableKeyMapping = true;
```

Do not duplicate ZMK layout logic in Karabiner. Keep Karabiner small and macOS-specific.

### Configuration Ownership

MacOS configuration lives inside `macos/`, even when duplicated from `arch/`.

- Keep nix-darwin state in `hosts/<hostname>/darwin.nix`.
- Keep Home Manager configuration split by program in `modules/home/`.
- Use native Home Manager modules when mature.
- Use `home.file` or `xdg.configFile` for native raw app formats.
- Keep generated, private, and secret-bearing files outside normal source deployment.
- Do not use Stow on macOS.

### Testing

Full macOS testing requires real macOS or VM.

Options:

- run manually on macOS workstation
- later evaluate Tart for VM testing
- add `mise run check macos` for static checks only

---

## Phase 2: NixOS Support

Goal: introduce `nixos/` as a complete standalone NixOS system and user config.

### Structure

Create:

```text
nixos/
├── flake.nix
├── flake.lock
├── hosts/
│   └── <hostname>/
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── home.nix
├── modules/
│   ├── system/
│   └── home/
├── setup/
│   └── main.sh
├── zsh/
├── nvim/
├── git/
├── starship/
└── ...
```

NixOS may manage many configs declaratively, but user-facing dotfiles still belong under `nixos/` when needed.

### Setup

1. Add `nixos/setup/main.sh` as entry point.
2. Add Nix flake.
3. Add host profile(s).
4. Add Home Manager config.
5. Add system modules for:
   - users
   - shells
   - graphics
   - audio
   - Bluetooth
   - networking
   - fonts
   - desktop/session
6. Add home modules for:
   - zsh
   - nvim
   - git
   - starship
   - tmux
   - terminal
   - scripts

### Dotfiles

NixOS dotfiles live inside `nixos/`, even if duplicate with `arch/`:

- `nixos/zsh/`
- `nixos/nvim/`
- `nixos/git/`
- `nixos/starship/`
- `nixos/tmux/`

Use Home Manager where practical. Use `stow` only for files better kept raw.

### Testing

Preferred checks:

```bash
nix flake check ./nixos
nix build ./nixos#nixosConfigurations.<host>.config.system.build.toplevel
```

Optional VM test:

```bash
nix build ./nixos#nixosConfigurations.<host>.config.system.build.vm
```

---

## Phase 3: Repo Integration

Keep integration minimal.

1. Update `init.sh` dispatch:
   - Arch to `arch/setup/main.sh`
   - macOS to `macos/setup/main.sh`
   - NixOS to `nixos/setup/main.sh`
2. Update `mise.toml` with useful checks:
   - `mise run build arch`
   - `mise run check macos`
   - `mise run check nixos`
3. Add SOPS recipient policy and make encrypted paths explicit per OS.
4. Keep `.gitignore` root-level.
5. Do not introduce shared dotfiles package.

---

## Decisions

| Question | Decision |
| --- | --- |
| Arch status | Implemented in `arch/` |
| Shared dotfiles | No `shared/` directory |
| Duplicate configs | Allowed and preferred across OS dirs |
| macOS system approach | nix-darwin + Home Manager, simple single-host structure first |
| macOS package approach | Nix first, Homebrew only where useful |
| macOS window manager | Aerospace |
| macOS launcher | Raycast |
| macOS keyboard remapping | Karabiner-Elements |
| macOS clipboard | Maccy |
| macOS native keyboard navigation | Homerow first, Shortcat fallback |
| macOS modal editing | kindavim trial after base setup |
| macOS status bar | SketchyBar deferred |
| NixOS approach | Flake + Home Manager |
| Deployment model | Each OS applies only its own configuration tree |

---

## Next Actions

1. Replace Mason editor tools with Nix packages, then evaluate Nixvim incrementally.
2. Add minimal macOS desktop defaults.
3. Add Karabiner, Aerospace, Raycast, Maccy, and navigation tools in stages.
4. Migrate retained Arch programs through Home Manager or raw XDG deployment.
5. Add macOS `sops-nix` + `age` secrets.
6. Validate bootstrap, then clean unused Mac source trees.
7. Create NixOS scaffold and first host.
7. Add minimal `mise` checks for macOS and NixOS.
