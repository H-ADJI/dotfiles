{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./aerospace
    ./alacritty
    ./colima
    ./direnv
    ./desktoppr
    ./fastfetch
    ./ghostty
    ./git
    ./glow
    ./hunk
    ./jnv
    ./jqp
    ./mise
    ./nh
    ./nvim
    ./opencode
    ./packages
    ./ssh
    ./starship
    ./tabiew
    ./taskwarrior
    ./television
    ./tmux
    ./yazi
    ./zsh
  ];

  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    aerospace
    alacritty
    brave
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
