{ config, nixosModules, ... }:
{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."noctalia/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${nixosModules}/noctalia/noctalia.toml";
}
