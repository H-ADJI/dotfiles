{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang
    cargo
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
    jankyborders
    zellij
  ];
}
