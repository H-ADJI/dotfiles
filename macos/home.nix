{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/aerospace/aerospace.nix
    ./modules/alacritty/alacritty.nix
    ./modules/colima.nix
    ./modules/direnv
    ./modules/desktoppr/desktoppr.nix
    ./modules/fastfetch.nix
    ./modules/ghostty.nix
    ./modules/git.nix
    ./modules/glow/glow.nix
    ./modules/hunk/hunk.nix
    ./modules/jnv/jnv.nix
    ./modules/jqp/jqp.nix
    ./modules/mise/mise.nix
    ./modules/nvim/neovim.nix
    ./modules/opencode.nix
    ./modules/packages.nix
    ./modules/ssh/ssh.nix
    ./modules/starship.nix
    ./modules/tabiew/tabiew.nix
    ./modules/taskwarrior.nix
    ./modules/television/television.nix
    ./modules/tmux/tmux.nix
    ./modules/yazi.nix
    ./modules/zsh/shell.nix
  ];

  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    brave
  ];
}
