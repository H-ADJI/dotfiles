{ config, nixosModules, ... }:
let
  wallpaper_dir = "${nixosModules}/hyprpaper/walls";
in
{
  xdg.configFile."walls".source = config.lib.file.mkOutOfStoreSymlink wallpaper_dir;
  services.hyprpaper = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = {
      splash = false;
      wallpaper = [
        {
          fit_mode = "cover";
          monitor = "";
          path = "${config.home.homeDirectory}/.config/walls/coa_nixos.png";
        }
      ];
    };
  };
}
