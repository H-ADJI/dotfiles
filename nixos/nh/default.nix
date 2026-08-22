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
      extraArgs = "--keep 5";
    };
    flake = nixosModules;
    osFlake = nixosModules;
  };
}
