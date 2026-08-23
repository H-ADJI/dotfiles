{
  nixosModules,
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
    flake = nixosModules;
    osFlake = nixosModules;
  };
}
