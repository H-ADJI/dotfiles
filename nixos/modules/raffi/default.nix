{
  config,
  nixosModules,
  ...
}:

let
  raffi_conf = "${nixosModules}/raffi/raffi.yaml";
in
{
  xdg.configFile."raffi/raffi.yml".source = config.lib.file.mkOutOfStoreSymlink raffi_conf;
}
