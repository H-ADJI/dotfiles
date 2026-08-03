{ config, nixosModules, ... }:
let
  hyprland_conf = "${nixosModules}/hypr/conf";
in
{

  xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink hyprland_conf;
}
