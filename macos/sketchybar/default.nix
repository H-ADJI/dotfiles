{
  config,
  pkgs,
  ...
}:
{
  programs.sketchybar = {
    enable = true;
    extraPackages = with pkgs; [
      blueutil
      config.programs.aerospace.package
    ];
    config = {
      source = ./config;
      recursive = true;
    };
  };
}
