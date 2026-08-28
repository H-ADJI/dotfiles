{ inputs, ... }:
{

  imports = [ inputs.noctalia.homeModules.default ];
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."noctalia/config.toml".source = ./noctalia.toml;
  xdg.configFile."noctalia/conf".source = ./conf;

  # Local noctalia plugin (highest-precedence data-dir drop-in).
  xdg.dataFile."noctalia/plugins/khalil/default-mic/plugin.toml".source = ./plugins/default-mic/plugin.toml;
  xdg.dataFile."noctalia/plugins/khalil/default-mic/widget.luau".source = ./plugins/default-mic/widget.luau;

}
