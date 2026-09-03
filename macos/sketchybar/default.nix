{
  pkgs,
  ...
}:
{
  programs.sketchybar = {
    enable = true;
    extraPackages = with pkgs; [
      blueutil
    ];
    config = {
      source = ./config;
      recursive = true;
    };
  };
}
