{ pkgs, ... }:
let
  hyprlandPreviewSharePickerSrc = pkgs.fetchgit {
    url = "https://github.com/WhySoBad/hyprland-preview-share-picker";
    rev = "e2f30ff85486e557018523da45ccbc846e3a499c";
    sha256 = "sha256-XE6RD/4Mhw/ZRBj0v94kLOERElat5V+e/X0L9eUGf7M=";
    fetchSubmodules = true;
  };
  hyprlandPreviewSharePicker = pkgs.callPackage "${hyprlandPreviewSharePickerSrc}/package.nix" {
    rev = "e2f30ff85486e557018523da45ccbc846e3a499c";
  };
in
{

  home.packages = with pkgs; [
    hyprlandPreviewSharePicker
    wayscriber
  ];

  xdg.configFile."hyprland-preview-share-picker/config.yaml".source = ./config.yaml;
  xdg.configFile."hyprland-preview-share-picker/share-picker.css".source = ./share-picker.css;
}
