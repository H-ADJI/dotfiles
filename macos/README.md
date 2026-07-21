# macOS Setup

First clean-install goal: get enough tools to continue building dotfiles comfortably.

Installs:

- Xcode Command Line Tools
- Lix
- Homebrew
- Google Chrome
- Ghostty
- OpenCode

Run:

```bash
cd ~/dotfiles
bash macos/setup/main.sh
```

If Xcode Command Line Tools installer opens, finish it, then re-run the script.

After bootstrap:

```bash
open -a Ghostty
opencode
```

Then continue with nix-darwin + Home Manager setup.
