{
  # macos-specific overrides of common zsh nix aliases
  programs.zsh.shellAliases = {
    nix_switch = "sudo darwin-rebuild switch --flake ~/PDE#macbook";
    nh_switch = "nh darwin switch";
  };
}
