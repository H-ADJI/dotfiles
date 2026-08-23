{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.hyprland-preview-share-picker.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."hyprland-preview-share-picker/config.yaml".source = ./config.yaml;
  xdg.configFile."hyprland-preview-share-picker/share-picker.css".source = ./share-picker.css;
}
