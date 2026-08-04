{
  config,
  pkgs,
  nixosModules,
  ...
}:
let
  # TODO: home manager module
  sunsetr = "${nixosModules}/sunsetr/sunsetr.toml";
in
{
  xdg.configFile."sunsetr/sunsetr.toml".source = config.lib.file.mkOutOfStoreSymlink sunsetr;

  systemd.user.services.sunsetr = {
    Unit = {
      Description = "Sunsetr - Automatic blue light filter for Hyprland, Niri, and everything Wayland";
      Documentation = "https://github.com/psi4j/sunsetr";
      PartOf = [ "graphical-session.target" ];
      Requires = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.sunsetr}/bin/sunsetr";
      Restart = "on-failure";
      RestartSec = 30;
    };
    Install.WantedBy = [ "hyprland-session.target" ];
  };
}
