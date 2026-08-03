{ config, pkgs, ... }:
let
  # path to your nvim config directory
  alacritty_conf = ./alacritty.toml;
in
{

  xdg.configFile."alacritty/themes/catppuccin_latte.toml".source =
    config.lib.file.mkOutOfStoreSymlink ./themes/catppuccin_latte.toml;
  xdg.configFile."alacritty/alacritty.toml".source =
    config.lib.file.mkOutOfStoreSymlink alacritty_conf;
}
