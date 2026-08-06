{
  config,
  nixosModules,
  ...
}:

let
  noctalia_conf = "${nixosModules}/raffi/noctalia.yml";
  tuis_conf = "${nixosModules}/raffi/tuis.yml";
in
{
  xdg.configFile = {
    "raffi/raffi.yaml".source = config.lib.file.mkOutOfStoreSymlink noctalia_conf;
    "raffi/tuis.yaml".source = config.lib.file.mkOutOfStoreSymlink tuis_conf;
  };
}
