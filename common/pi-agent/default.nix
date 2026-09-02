{
  pkgs,
  config,
  ...
}:
{
  home.file = {
    "${config.programs.pi-coding-agent.configDir}/zentui.json".source = ./agent/zentui.json;
    "${config.programs.pi-coding-agent.configDir}/clipboard.json".text = builtins.toJSON {
      enabled = true;
    };
  };

  xdg = {
    configFile = {
      "ponytail/config.json".text = builtins.toJSON {
        defaultMode = "full";
      };
      "pi/agent/caveman.json".text = builtins.toJSON {
        defaultLevel = "lite";
        showStatus = true;
      };
    };
  };

  programs.pi-coding-agent = {
    enable = true;
    extraPackages = [
      pkgs.nodejs
    ];
    settings = {
      defaultProvider = "opencode-go";
      defaultModel = "deepseek-v4-flash";
      defaultThinkingLevel = "high";
      tuiMode = "fullscreen";
      packages = [
        "npm:@narumitw/pi-tool"
        "git:github.com/jonjonrankin/pi-caveman"
        "git:github.com/DietrichGebert/ponytail"
        "git:github.com/hh9dj/pi-agent-extensions"
        "npm:pi-opencode-bridge"
        "npm:pi-context-view"
        "npm:pi-zentui"
      ];
      lastChangelogVersion = "0.84.0";
      theme = "light";
    };
    keybindings = {
      "tui.select.up" = [
        "up"
        "ctrl+p"
      ];
      "tui.select.down" = [
        "down"
        "ctrl+n"
      ];
      "tui.editor.historyNext" = [
        "down"
        "ctrl+n"
      ];
      "tui.editor.historyPrevious" = [
        "up"
        "ctrl+p"
      ];
      "app.editor.external" = "ctrl+e";
      "app.session.togglePath" = [ ];
      "app.session.toggleNamedFilter" = [ ];
      "app.session.resume" = "ctrl+r";
      "app.model.cycleForward" = [ ];
      "app.model.cycleBackward" = [ ];
      "app.thinking.cycle" = "ctrl+t";
      "app.thinking.toggle" = "ctrl+shift+t";
      "tui.input.tab" = [
        "tab"
        "ctrl+y"
      ];
      "tui.input.newLine" = "shift+enter";
    };
  };
}
