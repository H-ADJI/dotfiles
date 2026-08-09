{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  services.displayManager.ly.enable = true;
  nixpkgs.config.allowUnfree = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  networking.hostName = "nixos";
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  time.timeZone = "Europe/Paris";
  users.users.khalil = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
    ];
    shell = pkgs.zsh;
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
  environment.systemPackages = with pkgs; [
    vim
    curl
    neovim
    wget
  ];
  system.stateVersion = "26.05";
}
