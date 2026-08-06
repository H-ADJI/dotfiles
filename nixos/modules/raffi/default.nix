{
  config,
  nixosModules,
  ...
}:

let
  raffi_conf = "${nixosModules}/raffi/noctalia.yml";
in
{
  xdg.configFile."raffi/raffi.yaml".source = config.lib.file.mkOutOfStoreSymlink raffi_conf;
}
