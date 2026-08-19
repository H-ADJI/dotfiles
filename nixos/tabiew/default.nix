{ pkgs, ... }:
{
  home.packages = with pkgs; [ tabiew ];
  xdg.configFile."tabiew/config.toml".source = ./config.toml;
}
