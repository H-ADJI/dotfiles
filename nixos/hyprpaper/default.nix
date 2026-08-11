{ config, ... }:
{
  services.hyprpaper = {
    enable = false;
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
