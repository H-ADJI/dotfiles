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
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  users.users.khalil = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    curl
    neovim
    wget
  ];
  system.stateVersion = "26.05";
}
