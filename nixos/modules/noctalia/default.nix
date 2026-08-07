{
  config,
  nixosModules,
  ...
}:
{
  # TODO: plugins check :)
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."noctalia/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${nixosModules}/noctalia/noctalia.toml";
  xdg.configFile."noctalia/conf".source =
    config.lib.file.mkOutOfStoreSymlink "${nixosModules}/noctalia/conf";

}
