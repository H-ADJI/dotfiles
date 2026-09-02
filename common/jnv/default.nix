{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jnv
  ];
  xdg.configFile."jnv/config.toml".source = ./config.toml;
}
