{ pkgs, ... }:

{
  home.packages = with pkgs; [
    aerospace
    cargo
    clang
    coreutils
    curl
    docker
    docker-compose
    fd
    gh
    gnugrep
    gnutar
    go
    google-chrome
    hunk
    hyperfine
    mise
    nerd-fonts.jetbrains-mono
    nodejs
    podman
    podman-compose
    python3
    ripgrep
    rustc
    stow
    transcrypt
    tree
    uv
  ];
}
