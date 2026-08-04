{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # TODO: package : shuck / zshcs
    nerd-fonts.jetbrains-mono
    glow
    alacritty
    sunsetr
    go
    wl-clipboard
    cliphist
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
