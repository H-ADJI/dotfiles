{
  pkgs,
  config,
  lib,
  nixosModules,
  ...
}:
let
  piPackage = config.programs.pi-coding-agent.package;
  piAgentModule = "${nixosModules}/pi-agent";
  tsconfigFiles = import ./pi-ts-config.nix { inherit lib piPackage piAgentModule; };
in
{
  home.file = tsconfigFiles // {
    "${config.programs.pi-coding-agent.configDir}/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${piAgentModule}/agent/settings.json";
    "${config.programs.pi-coding-agent.configDir}/zentui.json".source =
      config.lib.file.mkOutOfStoreSymlink "${piAgentModule}/agent/zentui.json";
    "${config.programs.pi-coding-agent.configDir}/keybindings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${piAgentModule}/agent/keybindings.json";
    "${config.programs.pi-coding-agent.configDir}/extensions".source =
      config.lib.file.mkOutOfStoreSymlink "${piAgentModule}/extensions";
    "${config.programs.pi-coding-agent.configDir}/clipboard.json".text = builtins.toJSON {
      enabled = true;
    };
  };
  xdg.configFile."ponytail/config.json".text = builtins.toJSON {
    defaultMode = "full";
  };

  xdg.configFile."pi/agent/caveman.json".text = builtins.toJSON {
    defaultLevel = "lite";
    showStatus = true;
  };

  programs.pi-coding-agent = {
    enable = true;
    extraPackages = [
      pkgs.nodejs
    ];
  };
}
