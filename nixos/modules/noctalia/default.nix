{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      # This may also be a string or path to a .toml file.
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      wallpaper = {
        enabled = false;
        default.path = "/path/to/wallpapers/wallpaper.png";
      };
    };
  };
}
