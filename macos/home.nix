{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../common/alacritty
    ../common/direnv
    ../common/fastfetch
    ../common/ghostty
    ../common/git
    ../common/glow
    ../common/hunk
    ../common/jnv
    ../common/jqp
    ../common/mise
    ../common/nh
    ../common/nvim
    ../common/opencode
    ../common/pi-agent
    ../common/ssh
    ../common/starship
    ../common/tabiew
    ../common/taskwarrior
    ../common/television
    ../common/tmux
    ../common/yazi
    ../common/zsh
    ./aerospace
    ./colima
    ./desktoppr
    ./ghostty
    ./zsh
  ];

  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "26.05";

  home.file.".hushlogin".text = "";

  home.packages = with pkgs; [
    brave
    cargo
    clang
    coreutils
    curl
    docker
    docker-compose
    fd
    gnugrep
    gnutar
    go
    google-chrome
    hyperfine
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
