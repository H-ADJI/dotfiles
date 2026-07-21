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

  programs.zsh.enable = true;

  system.defaults.NSGlobalDomain = {
    ApplePressAndHoldEnabled = false;
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
  };
  system.keyboard.enableKeyMapping = true;

  system.stateVersion = 6;
}
