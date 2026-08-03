{ config, nixosModules, ... }:
let
  alacritty_conf = "${nixosModules}/alacritty/alacritty.toml";
  alacritty_theme = "${nixosModules}/alacritty/themes/catppuccin_latte.toml";
in
{

  xdg.configFile."alacritty/themes/catppuccin_latte.toml".source =
    config.lib.file.mkOutOfStoreSymlink alacritty_theme;
  xdg.configFile."alacritty/alacritty.toml".source =
    config.lib.file.mkOutOfStoreSymlink alacritty_conf;
}
