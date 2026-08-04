{
  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      theme = "Catppuccin Latte";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 20;
      font-style = "Bold";
      font-style-bold = true;
      font-style-italic = false;
      font-style-bold-italic = false;
      resize-overlay = "never";
      title = "Ghostty";
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";
      macos-option-as-alt = true;
      scrollbar = "never";
      scrollback-limit = 10000;
      confirm-close-surface = false;
      window-decoration = false;
      maximize = false;
      window-padding-x = 180;
      window-padding-y = 80;
    };
  };
}
