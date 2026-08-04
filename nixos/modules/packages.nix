{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    glow
    alacritty
    sunsetr
    go
    wl-clipboard
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
