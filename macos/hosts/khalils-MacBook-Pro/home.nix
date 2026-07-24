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
    ../../modules/home/jankyborders.nix
    ../../modules/home/taskwarrior.nix
    ../../modules/home/hunk.nix
    ../../modules/home/fastfetch.nix
    ../../modules/home/television.nix
    ../../modules/home/opencode.nix
    ../../modules/home/yazi.nix
    ../../modules/home/desktoppr.nix
  ];

  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "25.11";
}
