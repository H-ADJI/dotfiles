{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    alacritty
    google-chrome
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
  ];
}
