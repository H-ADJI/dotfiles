{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
  ];

  xdg.configFile."alacritty/themes/catppuccin_latte.toml".source = ./themes/catppuccin_latte.toml;
  xdg.configFile."alacritty/alacritty.toml".source = ./alacritty.toml;
}
