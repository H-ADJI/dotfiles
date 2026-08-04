{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    alacritty
    sunsetr
    go
    google-chrome
    brave
    neovim
    fuzzel
    tree
    fd
    fzf
    gnugrep
    hyperfine
    ripgrep
    bluetui
    pulsemixer
    opencode
    mpv
    nautilus
  ];
}
