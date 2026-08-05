{ config, nixosModules, ... }:
let
  walls_dir = "${nixosModules}/assets/walls";
in
{
  xdg.configFile."walls".source = config.lib.file.mkOutOfStoreSymlink walls_dir;
}
