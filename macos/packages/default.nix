{ pkgs, ... }:

{
  home.packages = with pkgs; [
    aerospace
    alacritty
    cargo
    clang
    coreutils
    curl
    docker
    docker-compose
    fd
    fzf
    gh
    glow
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
    usage
    uv
  ];
}
