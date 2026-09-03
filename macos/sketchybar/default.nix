{
  config,
  ...
}:
{
  programs.sketchybar = {
    enable = true;
    extraPackages = [ config.programs.aerospace.package ];
    config.source = ./sketchybarrc;
  };
}
