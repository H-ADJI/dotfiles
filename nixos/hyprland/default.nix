{ pkgs, ... }:
{
  xdg.configFile."hypr/xdph.conf".source = ./xdph.conf;

  home.pointerCursor = {
    enable = true;
    name = "catppuccin-latte-light-cursors";
    package = pkgs.catppuccin-cursors.latteLight;
    hyprcursor.enable = true;
    hyprcursor.size = 30;
  };

  wayland.windowManager.hyprland = {
    extraLuaFiles = {
      "lib.vars" = {
        content = ./lib/vars.lua;
        autoLoad = false;
      };
      "lib.conf" = ./lib/conf.lua;
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
    # plugins = [ pkgs.hyprlandPlugins.hypr-dynamic-cursors ];
    systemd = {
      variables = [ "--all" ];
      enable = true;
      enableXdgAutostart = true;
    };
  };
}
