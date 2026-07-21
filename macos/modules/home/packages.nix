{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang
    cargo
    curl
    fd
    gh
    gnugrep
    gnutar
    go
    google-chrome
    hyperfine
    mise
    neovim
    nodejs
    opencode
    python3
    ripgrep
    rustc
    stow
    television
    tree-sitter
    uv
    zellij
  ];
}
