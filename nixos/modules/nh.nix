{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/khalil/dotfiles/nixos"; # sets NH_OS_FLAKE variable for you
  };
}
