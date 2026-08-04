{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep-since 7d --keep 5";
    };
    flake = "/home/khalil/dotfiles/nixos"; # sets NH_OS_FLAKE variable for you
    osFlake = "/home/khalil/dotfiles/nixos"; # sets NH_OS_FLAKE variable for you
  };
}
