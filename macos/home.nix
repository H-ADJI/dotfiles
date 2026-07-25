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
    ./modules/jnv.nix
    ./modules/jqp.nix
    ./modules/mise.nix
    ./modules/fastfetch.nix
    ./modules/television/television.nix
    ./modules/opencode.nix
    ./modules/yazi.nix
    ./modules/desktoppr/desktoppr.nix
    ./modules/ssh/ssh.nix
    ./modules/tabiew.nix
  ];

  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "25.11";
}
