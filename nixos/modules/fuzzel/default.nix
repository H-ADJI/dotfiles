{
  config,
  nixosModules,
  ...
}:

let
  fuzzel_conf = "${nixosModules}/fuzzel/conf";
in
{
  xdg.configFile."fuzzel".source = config.lib.file.mkOutOfStoreSymlink fuzzel_conf;
}
