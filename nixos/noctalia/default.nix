{ inputs, pkgs, ... }:
{

  imports = [ inputs.noctalia.homeModules.default ];
  programs.noctalia = {
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."noctalia/config.toml".source = ./noctalia.toml;
  xdg.configFile."noctalia/conf".source = ./conf;

}
