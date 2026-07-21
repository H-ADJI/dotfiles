# ROADMAP — macOS and NixOS Dotfiles

## Status

- **Arch Linux** — implemented in `arch/`
- **macOS** — planned
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

### Structure

Create:

```text
macos/
├── flake.nix
├── flake.lock
├── hosts/
│   └── <hostname>/
│       ├── darwin.nix
│       └── home.nix
├── setup/
│   └── main.sh
├── zsh/
├── nvim/
├── git/
├── starship/
├── tmux/
├── ghostty/
├── aerospace/
├── karabiner/
├── raycast/
├── maccy/
└── ...
```

Copy/adapt from `arch/` only when useful. Do not move files into shared locations.

### Setup

1. Detect macOS in `init.sh` and dispatch to `macos/setup/main.sh`.
2. Bootstrap Lix on macOS.
3. Use nix-darwin + Home Manager.
   - Keep structure simple at first.
   - Prefer one host config before introducing reusable modules.
   - Add abstractions only when duplication becomes painful.
4. Add package management for:
   - CLI tools
   - GUI apps
   - fonts
   - development runtimes
5. Use `nix-homebrew` or plain Homebrew only if needed for apps Nix handles poorly.
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

### Clean Install Build Sequence

Start from a clean macOS reset and build in small verified layers.

#### Step 1: Manual First Boot

Do manually before dotfiles:

1. Finish macOS setup assistant.
2. Sign in to Apple ID only if needed.
3. Install system updates.
4. Open Terminal once.
5. Set keyboard input source to **English - ABC**.
6. Confirm network, iCloud/company enrollment, and security tooling are stable.

#### Step 2: Clone Dotfiles

Install Git if macOS prompts for it, then clone repo:

```bash
git clone git@github.com:H-ADJI/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

If SSH keys are not available yet, use HTTPS first and switch remote later.

#### Step 3: Create Minimal `macos/` Scaffold

Create only the base skeleton first:

```text
macos/
├── flake.nix
├── hosts/<hostname>/darwin.nix
├── hosts/<hostname>/home.nix
├── setup/main.sh
└── README.md
```

Do not copy all dotfiles yet. First goal is a working Nix/macOS rebuild.

#### Step 4: Install Lix

Use Lix installer, as recommended by nix-darwin:

```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

Then restart terminal and verify:

```bash
nix --version
```

For first-boot ergonomics, `macos/setup/main.sh` may be used before full nix-darwin exists. It installs:

- Lix
- Homebrew
- Google Chrome
- Ghostty
- OpenCode

This gives a browser, terminal, and agent before the declarative macOS config is complete.

#### Step 5: Add Minimal nix-darwin Flake

Start with one host only.

`flake.nix` should include:

- `nix-darwin`
- `home-manager`
- one `darwinConfigurations.<hostname>`

Keep `darwin.nix` minimal:

- enable flakes
- use `nix.package = pkgs.lix;`
- set username/home directory
- set hostname
- set keyboard repeat defaults
- install tiny package set only

Keep `home.nix` minimal:

- `home.stateVersion`
- shell basics
- Git basics
- no app ricing yet

#### Step 6: First Rebuild

Run nix-darwin directly first:

```bash
nix run nix-darwin -- switch --flake ~/dotfiles/macos#<hostname>
```

After first success, use:

```bash
darwin-rebuild switch --flake ~/dotfiles/macos#<hostname>
```

Do not continue until rebuild is clean.

#### Step 7: Add CLI Base

Add CLI packages gradually:

- `git`
- `stow`
- `zsh`
- `neovim`
- `tmux`
- `ripgrep`
- `fd`
- `eza`
- `bat`
- `jq`
- `fzf`
- `zoxide`
- `starship`
- `mise`

Rebuild and test after each small group.

#### Step 8: Add Dotfiles One Package At A Time

Copy/adapt dotfiles from `arch/` into `macos/` one package at a time:

1. `macos/git/`
2. `macos/zsh/`
3. `macos/starship/`
4. `macos/nvim/`
5. `macos/tmux/`
6. `macos/ghostty/`

After each package:

```bash
stow --dotfiles -d ~/dotfiles/macos -t ~ <package>
```

Then open a new shell/app and verify. Do not bulk-stow first pass.

#### Step 9: Add GUI Apps

Add GUI apps with Nix first when available. Use Homebrew only when needed.

Initial GUI apps:

- Ghostty
- Raycast
- Karabiner-Elements
- Maccy
- Aerospace
- Homerow or Shortcat

Keep `nix-homebrew` optional until needed. If company tooling already manages apps, do not fight it.

#### Step 10: Add Keyboard Setup

Configure in this order:

1. macOS input source: **English - ABC**
2. ZMK keyboard pairs and works normally
3. nix-darwin repeat settings
4. Karabiner modifier/fallback rules

Do not port full ZMK layout into Karabiner. Karabiner handles only macOS-specific remaps.

#### Step 11: Add Aerospace

Add `macos/aerospace/` after terminal and keyboard are stable.

First config should include only:

- focus directions
- move directions
- workspace 1/2/3
- move window to workspace 1/2/3
- terminal launch
- browser launch
- communication workspace rules

Match Hyprland keybinds where possible.

Defer gaps, rounded polish, and complex rules until tiling feels correct.

#### Step 12: Add Raycast and Maccy

Use Raycast for:

- app launcher
- command palette
- quick actions

Use Maccy for clipboard history unless Raycast clipboard fully replaces it.

#### Step 13: Add Native Keyboard Navigation

After base desktop is stable:

1. Try Homerow.
2. If Homerow does not fit, try Shortcat.
3. Trial kindavim for modal editing.

Keep only tools that earn daily use.

#### Step 14: Defer Bar/Ricing

Do not add SketchyBar during initial setup.

Add later only after:

- Aerospace stable
- Raycast stable
- Karabiner stable
- work apps stable

#### Step 15: Add `setup/main.sh`

Only after manual commands are proven, encode them in `macos/setup/main.sh`.

`main.sh` should:

1. verify macOS
2. verify Nix exists or print install command
3. run `darwin-rebuild switch --flake`
4. stow selected macOS dotfiles
5. avoid destructive actions

Keep first version boring and explicit.

#### Step 16: Add Checks

Add lightweight checks to `mise.toml`:

```bash
nix flake check ./macos
```

Optional later:

```bash
darwin-rebuild check --flake ./macos#<hostname>
```

#### Step 17: Document Machine-Specific Notes

Add `macos/README.md` with:

- hostname
- company restrictions found
- apps installed outside Nix
- manual steps still required
- rollback commands

Rollback basics:

```bash
darwin-rebuild --list-generations
darwin-rebuild switch --rollback
```

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

### Dotfiles

MacOS dotfiles live inside `macos/`, even if duplicate with `arch/`:

- `macos/zsh/`
- `macos/nvim/`
- `macos/git/`
- `macos/starship/`
- `macos/ghostty/`
- `macos/tmux/`
- `macos/aerospace/`
- `macos/karabiner/`
- `macos/raycast/`
- `macos/maccy/`

Use `stow --dotfiles` from `macos/` only.

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
3. Keep `.gitattributes` root-level and make encrypted paths explicit per OS.
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
| Deployment model | Each OS stows/applies only its own directory |

---

## Next Actions

1. Create `macos/` scaffold.
2. Add `macos/setup/main.sh`.
3. Add simple nix-darwin + Home Manager flake.
4. Create `nixos/` scaffold.
5. Add `nixos/flake.nix` and first host.
6. Update `init.sh` dispatch.
7. Add minimal `mise` checks for macOS and NixOS.
