{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    hyprland.enable = true;
    localsend.enable = true;
    zsh.enable = true;
  };

  services = {
    displayManager.ly.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      wireplumber.enable = true;
    };
  };
  security.rtkit.enable = true;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 10;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  time.timeZone = "Europe/Paris";

  users.users.khalil = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
    neovim
    wget
  ];

  system.stateVersion = "26.05";
}
