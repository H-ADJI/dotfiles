{
  imports = [
    ../../modules/home/packages.nix
    ../../modules/home/colima.nix
    ../../modules/home/git.nix
    ../../modules/home/neovim.nix
    ../../modules/home/shell.nix
    ../../modules/home/tmux.nix
    ../../modules/home/ghostty.nix
  ];

  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "25.11";
}
