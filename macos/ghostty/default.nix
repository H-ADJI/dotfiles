{
  # macos-specific ghostty overrides.
  # package = null: nixpkgs ghostty is linux-only; the app comes from the
  # homebrew cask, home-manager only manages the config.
  programs.ghostty = {
    package = null;
    settings = {
      font-size = 20;
      window-decoration = true;
    };
  };
}
