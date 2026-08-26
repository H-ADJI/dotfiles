{ pkgs, config, lib, nixosModules, ... }:
let
  piPackage = config.programs.pi-coding-agent.package;
  piAgentDir = "${nixosModules}/pi-agent";
  piTsconfig = builtins.toJSON {
    compilerOptions = {
      target = "ES2023";
      module = "ESNext";
      moduleResolution = "Bundler";
      noEmit = true;
      strict = true;
      skipLibCheck = true;
      paths = {
        "@earendil-works/pi-coding-agent" = [ "${piPackage}/lib/node_modules/pi-monorepo/dist/index.d.ts" ];
        "@earendil-works/pi-tui" = [ "${piPackage}/lib/node_modules/pi-monorepo/node_modules/@earendil-works/pi-tui/dist/index.d.ts" ];
        typebox = [ "${piPackage}/lib/node_modules/pi-monorepo/node_modules/typebox/build/index.d.mts" ];
      };
    };
  };
  piTsconfigPkg = builtins.toJSON {
    name = "pi-tsconfig";
    version = "1.0.0";
    private = true;
  };
in
{
  home.file."${piAgentDir}/node_modules/pi-tsconfig/package.json" = lib.mkIf (piPackage != null) {
    text = piTsconfigPkg;
  };

  home.file."${piAgentDir}/node_modules/pi-tsconfig/tsconfig.json" = lib.mkIf (piPackage != null) {
    text = piTsconfig;
  };

  home.file."${config.programs.pi-coding-agent.configDir}/zentui.json".source = ./zentui.json;
  home.file."${config.programs.pi-coding-agent.configDir}/extensions/ask-user.ts".source = ./extensions/ask-user.ts;

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
        # ask user tool
        # https://github.com/edlsh/pi-ask-user
        # https://github.com/IgorWarzocha/howaboua-pi-stuff/tree/main/packages/pi-ask
        # https://github.com/mrclrchtr/supi
        # https://github.com/anomalyco/opencode

        # advisor / plan mode
        # guardrails
        # sandbox
        # modern CLIs
        # browser automation
        # notifications
        # todos
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
      "tui.editor.cursorLeft" = [
        "left"
        "alt+h"
      ];
      "tui.editor.cursorRight" = [
        "right"
        "alt+l"
      ];
      "tui.editor.cursorUp" = [
        "up"
        "alt+k"
      ];
      "tui.editor.cursorDown" = [
        "down"
        "alt+j"
      ];
      "tui.select.up" = [
        "up"
        "ctrl+k"
      ];
      "tui.select.down" = [
        "down"
        "ctrl+j"
      ];
      "app.editor.external" = [ "ctrl+e" ];
      "tui.input.tab" = [
        "tab"
        "ctrl+y"
      ];
      "tui.input.newLine" = [ "shift+enter" ];
    };
  };
}
