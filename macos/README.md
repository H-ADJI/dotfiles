# macOS Setup

Nix-darwin + Home Manager workstation configuration for `khalils-MacBook-Pro`.

Ownership:

- Lix
- nix-darwin + Home Manager: system, user packages, and dotfiles
- nix-homebrew: Homebrew installation
- Homebrew cask: Ghostty
- Nix: Google Chrome and OpenCode

Run:

```bash
cd ~/dotfiles
bash macos/setup/main.sh
```

First run installs Lix when missing, then stops. Restart terminal and run script again. Later runs use `darwin-rebuild`.

Verify:

```bash
open -a Ghostty
opencode
```
