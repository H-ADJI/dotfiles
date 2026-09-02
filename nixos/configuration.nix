{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  # audio recording specialisation: nh_switch --specialisation=audio
  specialisation.audio.configuration.imports = [ ./audio-station.nix ];

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  nix.settings.extra-substituters = [ "https://noctalia.cachix.org" ];
  nix.settings.extra-trusted-public-keys = [
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
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
    udev.packages = with pkgs; [
      vial
    ];
  };
  security.rtkit.enable = true;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
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
