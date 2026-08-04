{ config, nixosModules, ... }:
let
  ashell_conf = "${nixosModules}/ashell/ashell.toml";
in
{
  xdg.configFile."ashell/ashell.toml".source = config.lib.file.mkOutOfStoreSymlink ashell_conf;
  programs.ashell = {
    enable = true;
    systemd.enable = true;
  };

}
