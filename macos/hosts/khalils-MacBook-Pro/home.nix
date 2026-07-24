{
  imports = [
    ../../modules/home/packages.nix
    ../../modules/home/colima.nix
    ../../modules/home/git.nix
    ../../modules/home/neovim.nix
    ../../modules/home/shell.nix
    ../../modules/home/tmux.nix
    ../../modules/home/ghostty.nix
    ../../modules/home/aerospace.nix
    ../../modules/home/clipcat.nix
    ../../modules/home/jankyborders.nix
  ];

  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "25.11";
}
