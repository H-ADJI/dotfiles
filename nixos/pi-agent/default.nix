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
    "${config.programs.pi-coding-agent.configDir}/zentui.json".source = ./agent/zentui.json;
    "${config.programs.pi-coding-agent.configDir}/offpeak-deepseek.json".source =
      ./agent/offpeak-deepseek.json;
    "${config.programs.pi-coding-agent.configDir}/extensions".source = ./extensions;
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
    settings = {
      defaultProvider = "deepseek";
      defaultModel = "deepseek-v4-flash";
      defaultThinkingLevel = "low";
      tuiMode = "fullscreen";

      packages = [
        # advisor / plan mode
        # guardrails
        # sandbox
        # modern CLIs
        # browser automation
        # notifications
        # todos
        # price per turn
        # copy msg on turn end
        # subagents
        # prompts
        # skills : reviewer
        # skills : refactor - improve
        # skills : token efficiency
        # anthropic auth
        # free models
        # https://pi.dev/packages/opencode-pi
        # https://pi.dev/packages/pi-opencode-native
        # https://pi.dev/packages/pi-zero
        # https://pi.dev/packages/pi-free
        # https://pi.dev/packages/pi-freerouter
        # https://pi.dev/packages/pi-bansos

        # TODO: auto-copy after response / open reponse in reader
        # "npm:@narumitw/pi-plan-mode"
        # "npm:@zenspc/pi-workflow"
        "npm:@narumitw/pi-tool"
        "npm:pi-zentui@0.20.2"
        "git:github.com/jonjonrankin/pi-caveman"
        "git:github.com/DietrichGebert/ponytail"
        {
          "source" = "npm:@zenspc/pi-devtools";
          "extensions" = [ "extensions/context-command.ts" ];
        }
      ];
      /*
        plan / task / goals
          plan-mode
          https://pi.dev/packages/@agent-plan/pi-adapter
          https://pi.dev/packages/@bacnh85/pi-plan
          https://pi.dev/packages/@janvitos/pi-plan-build
          https://pi.dev/packages/pi-codex-goal
          https://pi.dev/packages/@mjasnikovs/pi-task
          https://pi.dev/packages/@tintinweb/pi-tasks
          https://pi.dev/packages/pi-crew
          https://pi.dev/packages/@agimon-ai/doompi-task
          https://pi.dev/packages/@agimon-ai/doompi-plan
          https://pi.dev/packages/@noice-tech/pi-cutover

        context / token efficiency
          https://pi.dev/packages/@mrclrchtr/supi-context
          https://pi.dev/packages/@hypabolic/pi-hypa
          https://pi.dev/packages/pi-cache-optimizer
          https://pi.dev/packages/@danypops/pi-lector
          https://pi.dev/packages/pi-caveman
          https://pi.dev/packages/pi-reasonix
          https://pi.dev/packages/pi-observational-memory
          https://pi.dev/packages/@mrclrchtr/supi-cache

          todo list : https://pi.dev/packages/@juicesharp/rpiv-todo
          https://pi.dev/packages/@juicesharp/rpiv-todo

        side conversations (/btw)
          https://pi.dev/packages/@narumitw/pi-btw
          https://pi.dev/packages/pi-btw
          https://pi.dev/packages/@juicesharp/rpiv-btw

        review / guardrails
          https://pi.dev/packages/@plannotator/pi-extension
          https://pi.dev/packages/@juicesharp/rpiv-advisor
          https://pi.dev/packages/@aliou/pi-guardrails

        search
          https://pi.dev/packages/pi-deepseek-search
          https://pi.dev/packages/donsetch
          https://pi.dev/packages/@houndmcp/hound-mcp-pi
          https://pi.dev/packages/pi-smart-fetch
          https://pi.dev/packages/@mrclrchtr/supi-web
          https://pi.dev/packages/dripline
      */

    };
    keybindings = {
      "tui.select.up" = [
        "up"
        "ctrl+k"
      ];
      "tui.select.down" = [
        "down"
        "ctrl+j"
      ];
      "app.editor.external" = [ "ctrl+e" ];
      "app.model.select" = [ ];
      "app.model.cycleForward" = [ ];
      "app.model.cycleBackward" = [ ];
      "app.thinking.cycle" = "tab";
      "tui.input.tab" = [
        "ctrl+y"
      ];
      "tui.input.newLine" = [ "shift+enter" ];
    };
  };
}
