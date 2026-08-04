{ config, nixosModules, ... }:
let
  ashell_conf = "${nixosModules}/ashell/config.toml";
in
{
  xdg.configFile."ashell/config.toml".source = config.lib.file.mkOutOfStoreSymlink ashell_conf;
  programs.ashell = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };

}
