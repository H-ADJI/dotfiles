{ pkgs, ... }: {
  xdg.configFile."mise/config.toml".source = ./config.toml;
  home.packages = with pkgs; [
    mise
  ];

}
