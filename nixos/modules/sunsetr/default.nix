{ config, nixosModules, ... }:
let
  sunsetr = "${nixosModules}/sunsetr/sunsetr.toml";
in
{

  xdg.configFile."sunsetr/sunsetr.toml".source = config.lib.file.mkOutOfStoreSymlink sunsetr;
}
