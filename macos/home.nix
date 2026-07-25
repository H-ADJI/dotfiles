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
    ./modules/hunk/hunk.nix
    ./modules/jnv/jnv.nix
    ./modules/jqp/jqp.nix
    ./modules/mise/mise.nix
    ./modules/fastfetch.nix
    ./modules/television/television.nix
    ./modules/opencode.nix
    ./modules/yazi.nix
    ./modules/desktoppr/desktoppr.nix
    ./modules/ssh/ssh.nix
    ./modules/tabiew/tabiew.nix
  ];

  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "25.11";
}
