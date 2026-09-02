{
  lib,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = lib.mkDefault "Catppuccin Latte";
      font-family = lib.mkDefault "JetBrainsMono Nerd Font";
      font-size = lib.mkDefault 16;
      font-style = lib.mkDefault "Bold";
      font-style-bold = lib.mkDefault true;
      font-style-italic = lib.mkDefault false;
      font-style-bold-italic = lib.mkDefault false;
      resize-overlay = lib.mkDefault "never";
      title = lib.mkDefault "Ghostty";
      cursor-style = lib.mkDefault "block";
      cursor-style-blink = lib.mkDefault false;
      shell-integration-features = lib.mkDefault "no-cursor";
      macos-option-as-alt = lib.mkDefault true;
      scrollbar = lib.mkDefault "never";
      scrollback-limit = lib.mkDefault 10000;
      confirm-close-surface = lib.mkDefault false;
      window-decoration = lib.mkDefault false;
      maximize = lib.mkDefault false;
      window-padding-x = lib.mkDefault 180;
      window-padding-y = lib.mkDefault 80;
    };
  };
}
