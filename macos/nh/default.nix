{
  darwinModules,
  ...
}:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 3";
    };
    flake = darwinModules;
    darwinFlake = darwinModules;
  };
}
