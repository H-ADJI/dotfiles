{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."noctalia/config.toml".source = ./noctalia.toml;
  xdg.configFile."noctalia/conf".source = ./conf;

}
