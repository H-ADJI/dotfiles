{
  imports = [
    ./modules/ssh
    ./modules/packages.nix
    ./modules/git.nix
  ];

  home.username = "khalil";
  home.homeDirectory = "/home/khalil";
  home.stateVersion = "25.11";
}
