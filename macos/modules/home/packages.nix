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
    hunk
    gnugrep
    gnutar
    go
    google-chrome
    hyperfine
    mise
    nodejs
    python3
    podman
    podman-compose
    ripgrep
    rustc
    stow
    uv
    aerospace
    zellij
  ];
}
