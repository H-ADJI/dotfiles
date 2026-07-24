{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang
    cargo
    curl
    docker
    docker-compose
    fd
    fzf
    gh
    gnugrep
    gnutar
    go
    google-chrome
    hyperfine
    clipcat
    mise
    nodejs
    opencode
    python3
    podman
    podman-compose
    ripgrep
    rustc
    stow
    television
    uv
    aerospace
    zellij
  ];
}
