{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.package = pkgs.lix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.khalil = {
    home = "/Users/khalil";
    shell = pkgs.zsh;
  };

  system.primaryUser = "khalil";
  networking.hostName = "khalils-MacBook-Pro";

  environment.systemPackages = with pkgs; [
    bat
    bat-extras.batman
    clang
    cargo
    curl
    direnv
    delta
    eza
    fd
    fzf
    git
    gh
    gnugrep
    gnutar
    go
    gzip
    hyperfine
    mise
    neovim
    nodejs
    python3
    ripgrep
    rustc
    starship
    stow
    television
    tree-sitter
    uv
    unzip
    zellij
    zsh
    zoxide
  ];

  programs.zsh.enable = true;

  system.defaults.NSGlobalDomain = {
    ApplePressAndHoldEnabled = false;
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
  };
  system.keyboard.enableKeyMapping = true;

  system.stateVersion = 6;
}
