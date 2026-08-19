{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  nixpkgs.config.allowUnfree = true;

  programs.hyprland.enable = true;
  programs.localsend.enable = true;
  programs.zsh.enable = true;

  services.displayManager.ly.enable = true;
  services.upower.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  networking.hostName = "nixos";
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  time.timeZone = "Europe/Paris";

  users.users.khalil = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = [ pkgs.ardour ];
  };

  environment.systemPackages = with pkgs; [
    vim
    curl
    neovim
    wget
  ];

  system.stateVersion = "26.05";
}
