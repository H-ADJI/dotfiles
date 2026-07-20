# ROADMAP — Multi-OS Dotfiles Migration

## Status

- **Arch Linux** — implemented (branch: `migration/multi_os_setup`, dir: `arch/`)
- **macOS** — planned
- **NixOS** — planned

---

## Phase 0: Fix `arch/` Implementation (current bugs)

Existing `arch/` setup works conceptually but has bugs and fragility.

### main.sh

1. **Does not execute setup.** `launch_setup` is defined in `.bashrc` but never called. Add `launch_setup` call at end of main.sh (non-interactive mode).

2. **Redundant `sudo pacman -Syu`.** First line does full upgrade, then immediately installs specific packages. Remove the bare `-Syu` line — the package install will sync implicitly with `--needed --disable-download-timeout`.

3. **Broken PATH export.** `export PATH=$PATH:~/$SETUP_DIR` adds a directory path that contains no executable scripts. Remove line.

4. **Hardcoded branch.** `--branch migration/multi_os_setup` in clone URL. Detect current branch instead, or make branch an ARG in the container build.

### packages.sh

5. ~~Fragile `SETUP_DIR` path.~~ **Resolved.** All setup merged into single `main.sh`. No more `SETUP_DIR/lib` path issue.

### dotfiles.sh

6. **Password hash duplicated.** Hardcoded `STORED_HASH` in `dotfiles.sh` duplicates `setup/lock.secure`. Read from the file (single source of truth), or keep one authoritative file under `arch/setup/`.

7. **Debug leftover.** Line 36: `echo "package"` — remove.

8. **Hardcoded compositor config removal.** `rm -rf "$HOME/.config/hypr"` — acceptable since hypr-only decision confirmed, but document intent.

9. **`cd` without explicit target.** `cd || exit 1` relies on `cd` defaulting to `$HOME`. Use `cd "$HOME" || exit 1`.

### System state

10. **Hypr-specific polkit.** `systemctl --user enable --now hyprpolkitagent` — only valid on hyprland. Conditionally skip or move to compositor-specific section if sway support ever returns.

### Testing infra

11. **Containerfile** has `ENTRYPOINT` + `CMD` that runs `init.sh | bash` then `exec bash`. This pipes setup scripts through bash which is unusual — the old monolithic `setup/setup` grew out of this approach. The `arch/setup/` lib scripts should run directly. Consider changing CMD to `bash dotfiles/arch/setup/main.sh` after clone.

12. **Hardcoded salt in mise.toml** (`--build-arg PASS=0806`). Acceptable for dev containers (salt is not secret), but document that this is the argon2 salt, not the master password.

---

## Phase 1: Consolidate & Stabilise `arch/`

After Phase 0 fixes, improve the arch setup:

1. **Modular runner.** Instead of `launch_setup` defining functions in `.bashrc`, create an orchestrator script `arch/setup/run.sh` that sources and runs each lib script sequentially with proper error handling (`set -euo pipefail`).

2. ~~Shared lib.~~ **Superseded.** Scripts merged into single `main.sh`, no lib directory.

3. **Container test pass.** Verify `mise run build arch && mise run test arch` completes successfully with no interactive prompts (except password verification).

4. **Merge latest root-level changes from `master`.** Compare `master` root-level configs against `arch/` subtree. Current drift is minimal:
   - `scripts/dot-config/scripts/current_song` — one-line playerctl format change
   - `aichat/dot-config/aichat/config.yaml` — identical
   - Encrypted files (ssh, secrets, leetcode, zsh_history) — differ per encryption, content same

   Port `current_song` change to `arch/`, verify aichat config identical, then proceed.

5. **Delete root-level config duplicates** (zsh/, nvim/, hypr/, tmux/, etc.) once `arch/` stow verified. Stow target is `arch/` now.

6. **Delete old `setup/` directory** (monolithic `setup/setup`, old Containerfile, old requirements). All functionality ported to `arch/setup/main.sh`.

7. **Single `.gitattributes` and `.gitignore` at root.** Remove `arch/.gitattributes` and `arch/.gitignore` — files inside `arch/` are matched by root-level patterns. Update root `.gitattributes` paths to reference `arch/` variants where needed (e.g., `arch/zsh/dot-zsh_history`).

---

## Phase 2: Per-OS Directory Scaffold

Create the multi-OS skeleton that `init.sh` dispatches to:

```
dotfiles/
├── init.sh                 # unchanged, dispatches to $OS/setup/main.sh
├── arch/                   # exists — Arch dotfiles + setup
├── macos/                  # create — macOS dotfiles + setup (see Phase 3)
├── nixos/                  # create — NixOS dotfiles + setup (see Phase 4)
├── shared/                 # create — cross-OS dotfiles (git, ssh, starship, nvim, zsh, tmux, wezterm, etc.)
├── archinstall/            # Arch-specific OS installer configs
├── mise.toml               # update — add build/test tasks for macos, nixos
├── .gitattributes          # root-level, covers all OS subdirs
└── .gitignore              # root-level, covers all OS subdirs
```

**Key insight:** Many dotfiles are OS-independent (gitconfig, starship, nvim, tmux, wezterm, zsh, etc.). Instead of duplicating under each OS directory, create `shared/` for cross-OS configs. Each OS's `setup/main.sh` stows both `shared/` and its OS-specific dir.

This mirrors the stow command pattern:
```bash
stow --dotfiles -d "$HOME/dotfiles/shared" -t "$HOME" */
stow --dotfiles -d "$HOME/dotfiles/$CURRENT_OS" -t "$HOME" */
```

**Directory layout after scaffold:**

| Path | Content |
|------|---------|
| `shared/` | OS-independent configs (git, starship, nvim, tmux, zsh, wezterm, ssh, bat, etc.) |
| `arch/` | Linux/Arch-specific configs (hypr, waybar, pipewire, arch-specific scripts) |
| `macos/` | macOS-specific configs (yabai/skhd/aerospace, sketchybar, macOS defaults, brew) |
| `nixos/` | NixOS config (flake.nix, hardware configs, home-manager modules) |

**Migration:**
- Identify which current `arch/` configs are OS-independent and move to `shared/`.
- Keep Arch-specific configs (hypr, waybar, pipewire, pulsemixer, fuzzel, swappy) in `arch/`.
- Git history preserved via `git mv` per directory.

---

## Phase 3: macOS Support (Nix-based)

**Approach:** Nix + home-manager on macOS for package management and declarative user env. Optionally nix-darwin for system config.

1. Create `macos/setup/main.sh` — entry point for macOS setup
2. Bootstrap Nix (Determinate Systems installer or official)
3. Apply home-manager flake (shared dotfiles + macOS-specific modules)
4. Install brew packages (GUI apps, fonts) via home-manager's nix-homebrew integration
5. Configure macOS defaults (dock, trackpad, keyboard, finder)
6. Window manager: evaluate yabai/skhd vs aerospace (community preference shift toward aerospace)
7. Stow shared/ + macos/ for non-Nix-managed dotfiles

**Container testing:** Docker on macOS runs Linux containers — cannot fully test macOS GUI setup. Consider:
- `mise run test macos` — runs arch container to validate shared/ configs (still useful)
- Virtualise macOS via Tart or similar for full testing (deferred)

---

## Phase 4: NixOS Support

**Approach:** Full NixOS flake with home-manager.

1. Create `nixos/setup/main.sh` — entry point for NixOS setup (likely minimal — NixOS already manages everything)
2. Create `nixos/flake.nix` — system config, hardware configs, home-manager modules
3. Shared dotfiles consumed via home-manager (programs.<tool>.enable = true) rather than stow
4. Stow only non-Nix-managed leftovers in shared/

**Testing:** `nixos-rebuild build-vm` or `nix build .#nixosConfigurations.<name>.config.system.build.vm`

---

## Phase 5: Cleanup & CI

1. Remove `arch/setup/hypr/requirements.txt` and `arch/setup/sway/requirements.txt` (sway dropped, hypr packages in main requirements)
2. Rename branch from `migration/multi_os_setup` to `main` (or merge to master) after all OS paths functional
3. Add CI (GitHub Actions) for:
   - `mise run build arch` smoke test on each PR
   - Lint shell scripts (`shellcheck`)
   - Validate `.stow-local-ignore` coverage
4. Update AGENTS.md to reflect new structure
5. Archive/remove old `setup/` directory

---

## Decisions Made

| Question | Decision |
|----------|----------|
| Compositor choice | Hypr only. Sway dropped. |
| Old `setup/` dir | Remove after `arch/` stable. |
| Root-level config dupes | Keep only `arch/` after merging latest root-level changes from master. |
| OS-independent configs | Move to `shared/` directory, stow from there. |

---

## File Tracking

### To delete (after stablisation)
- `arch/.gitattributes` — merge into root `.gitattributes`
- `arch/.gitignore` — merge into root `.gitignore`
- `setup/` (entire directory) — legacy monolithic setup
- Root-level config dirs (zsh/, nvim/, tmux/, etc.) — replaced by `arch/` + `shared/`

### To modify
- `arch/setup/main.sh` — bugfixes per Phase 0
- `arch/setup/main.sh` — unified setup script (was 5 separate lib files)
- `init.sh` — optional: detect branch dynamically
- `mise.toml` — add macos/nixos tasks
- `.gitattributes` — update paths for new structure

### To create
- `shared/` — OS-independent configs (carved from current `arch/`)
- `macos/` — macOS-specific configs + `setup/`
- `nixos/` — NixOS flake + `setup/`
- `arch/setup/run.sh` — orchestrator runner
- `arch/setup/lib/` — **Deleted.** All scripts merged into `main.sh`.

---

## Sequence

```
Phase 0 (bugfixes)
  └─► Phase 1 (consolidate arch/)
        └─► Phase 2 (shared/ + per-OS scaffold)
              └─► Phase 3 (macOS)
                    └─► Phase 4 (NixOS)
                          └─► Phase 5 (cleanup + CI)
```
