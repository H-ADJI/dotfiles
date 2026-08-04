{ config, nixosModules, ... }:
let
  hyprland_conf = "${nixosModules}/hypr/conf";
in
{
  # xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink hyprland_conf;
  wayland.windowManager.hyprland = {
    extraLuaFiles = {
      "lib.vars" = {
        content = ./lib/vars.lua;
        autoLoad = false;
      };
      "lib.conf" = ./lib/conf.lua;
      "lib.autostart" = ./lib/autostart.lua;
      "lib.env" = ./lib/env.lua;
      "lib.keybinds" = ./lib/keybinds.lua;
      "lib.monitors" = ./lib/monitors.lua;
      "lib.rules" = ./lib/rules.lua;
      "lib.animations" = ./lib/animations.lua;
      "lib.layout" = ./lib/layout.lua;
      "lib.helpers" = {
        content = ./lib/helpers.lua;
        autoLoad = false;
      };
    };
    xwayland.enable = true;
    configType = "lua";
    enable = true;
    systemd = {
      variables = [ "--all" ];
      enable = true;
      enableXdgAutostart = true;
    };
  };
}
