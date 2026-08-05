{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # TODO: package : shuck / zshcs
    nerd-fonts.jetbrains-mono
    glow
    alacritty
    raffi
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
    libnotify
    opencode
    mpv
    nautilus
  ];
}
