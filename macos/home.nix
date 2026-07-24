{
  imports = [
    ./modules/packages.nix
    ./modules/colima.nix
    ./modules/git.nix
    ./modules/nvim/neovim.nix
    ./modules/shell.nix
    ./modules/tmux/tmux.nix
    ./modules/ghostty.nix
    ./modules/aerospace/aerospace.nix
    ./modules/taskwarrior.nix
    ./modules/hunk.nix
    ./modules/fastfetch.nix
    ./modules/television.nix
    ./modules/opencode.nix
    ./modules/yazi.nix
    ./modules/desktoppr/desktoppr.nix
    ./modules/secrets/secrets.nix
  ];

  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "25.11";
}
