{ ... }:
{
  programs.alacritty = {
    enable = true;
    theme = "catppuccin_latte";
    settings = {
      env.TERM = "xterm-256color";
      window = {
        padding.x = 180;
        padding.y = 90;
        startup_mode = "Maximized";
      };
      scrolling.history = 10000;
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 16;
      };
      keyboard.bindings = [
        {
          key = "Enter";
          mods = "Alt";
          chars = "\\u001b[13;3u";
        }
        {
          key = "Enter";
          mods = "Shift";
          chars = "\\u001b[13;2u";
        }
      ];
    };
  };
}
