{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang
    cargo
    colima
    curl
    docker
    docker-compose
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
    podman
    podman-compose
    ripgrep
    rustc
    stow
    television
    tree-sitter
    uv
    zellij
  ];
}
