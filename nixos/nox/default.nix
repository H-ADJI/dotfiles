{ inputs, ... }:
{

  home.packages = [
    inputs.nox.packages.x86_64-linux.default
  ];

  xdg.configFile."nox/nox.toml".source = ./nox.toml;

}
