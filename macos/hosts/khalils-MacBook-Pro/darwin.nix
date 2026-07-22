{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.lix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix-homebrew = {
    enable = true;
    user = "khalil";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    casks = [ "ghostty" ];
  };

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
    "com.apple.swipescrolldirection" = false;
    "com.apple.mouse.tapBehavior" = 1;
  };
  system.defaults.trackpad = {
    Clicking = true;
    TrackpadRightClick = true;
  };
  system.keyboard.enableKeyMapping = true;

  system.stateVersion = 6;
}
