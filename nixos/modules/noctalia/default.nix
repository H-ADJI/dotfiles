{
  config,
  nixosModules,
  ...
}:

let
  noctalia_entrypoint = "${nixosModules}/noctalia/noctalia.toml";
  noctalia_conf = "${nixosModules}/noctalia/conf";
in
{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."noctalia/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink noctalia_entrypoint;
  xdg.configFile."noctalia/conf".source = config.lib.file.mkOutOfStoreSymlink noctalia_conf;

}
