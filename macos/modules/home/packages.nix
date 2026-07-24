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
    nerd-fonts.jetbrains-mono
    nodejs
    python3
    podman
    podman-compose
    ripgrep
    rustc
    stow
    transcrypt
    uv
    age
    aerospace
    zellij
  ];
}
