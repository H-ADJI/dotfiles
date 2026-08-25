{ pkgs, config, ... }:
{
  home.file."${config.programs.pi-coding-agent.configDir}/zentui.json".source = ./zentui.json;

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
        # TODO: add my own ask - todos - plan extension packages inspired by opencode
        # TODO: auto-copy after response / open reponse in reader
        # "npm:@narumitw/pi-plan-mode"
        # "npm:@zenspc/pi-workflow"
        # "npm:@juicesharp/rpiv-ask-user-question"
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

        rendering / preview
          https://pi.dev/packages/@xynogen/pix-pretty
          https://pi.dev/packages/pi-markdown-preview
          https://pi.dev/packages/pi-spark
          https://pi.dev/packages/@geminixiang/pi-diff
          https://pi.dev/packages/@geminixiang/pi-mermaid
          https://pi.dev/packages/@heyhuynhgiabuu/pi-pretty

        context / token efficiency
          context inspection
          last message popup viewer
          https://pi.dev/packages/@zenspc/pi-devtools
          https://pi.dev/packages/pi-lean-ctx
          https://pi.dev/packages/@mrclrchtr/supi-context
          https://pi.dev/packages/@hypabolic/pi-hypa
          https://pi.dev/packages/pi-cache-optimizer
          https://pi.dev/packages/@danypops/pi-lector
          https://pi.dev/packages/pi-caveman
          https://pi.dev/packages/pi-reasonix
          https://pi.dev/packages/pi-observational-memory
          https://pi.dev/packages/@mrclrchtr/supi-cache

        skills / workflows
          skills : github repo
          skills : review - annotations
          skills : refactor - improve
          skills : token efficiency
          skills : docs
          https://pi.dev/packages/bigpowers
          https://pi.dev/packages/@juicesharp/rpiv-pi
          https://pi.dev/packages/gentle-pi
          https://pi.dev/packages/@howaboua/pi-stuff
          https://pi.dev/packages/mitsupi
          https://pi.dev/packages/@shanepadgett/tau-agent
          https://pi.dev/packages/pi-sych
          https://pi.dev/packages/@dietrichgebert/ponytail
          https://pi.dev/packages/@cgh567/agent
          https://pi.dev/packages/@zhcsyncer/pi-extensions
          https://pi.dev/packages/@howaboua/pi-extensions
          https://pi.dev/packages/@juicesharp/rpiv-workflow
          https://pi.dev/packages/bestony-pi-preset
          https://pi.dev/packages/@agimon-ai/doompi

        teams / agents
          https://pi.dev/packages/zob-harness
          https://pi.dev/packages/@hypercarrier/pi-team-bright
          https://pi.dev/packages/@vanillagreen/pi-agents-tmux
          https://pi.dev/packages/@giladbarnea/pi-simple-team
          https://pi.dev/packages/pi-maestro-teammate

        prompts
          https://pi.dev/packages/pi-prompt-template-model
          https://pi.dev/packages/@sreetej510/pi-prompt-manager

        todo / tickets
          todo list : https://pi.dev/packages/@juicesharp/rpiv-todo
          https://pi.dev/packages/@juicesharp/rpiv-todo
          https://pi.dev/packages/@danypops/pi-tickets

        ask user / questions
          https://pi.dev/packages/@juicesharp/rpiv-ask-user-question
          https://pi.dev/packages/pi-ask-user
          https://pi.dev/packages/@zhushanwen/pi-ask-user
          https://pi.dev/packages/@mrclrchtr/supi-ask-user

        side conversations (/btw)
          https://pi.dev/packages/@narumitw/pi-btw
          https://pi.dev/packages/pi-btw
          https://pi.dev/packages/@juicesharp/rpiv-btw

        review / guardrails
          https://pi.dev/packages/@plannotator/pi-extension
          https://pi.dev/packages/@juicesharp/rpiv-advisor
          https://pi.dev/packages/@aliou/pi-guardrails

        web UI
          https://pi.dev/packages/@hyperdreamer/pi-webui
          https://pi.dev/packages/@jmfederico/pi-web
          https://pi.dev/packages/@firstpick/pi-package-webui
          https://pi.dev/packages/pi-studio

        search
          https://pi.dev/packages/pi-deepseek-search
          https://pi.dev/packages/donsetch
          https://pi.dev/packages/@houndmcp/hound-mcp-pi
          https://pi.dev/packages/pi-smart-fetch
          https://pi.dev/packages/@mrclrchtr/supi-web
          https://pi.dev/packages/dripline

        docs
          https://pi.dev/packages/@firstpick/pi-extension-nixos-wiki-local
          https://pi.dev/packages/@agentskit/doc-bridge

        usage / stats
          https://pi.dev/packages/@sreetej510/pi-usage
          https://pi.dev/packages/@tmustier/pi-usage-extension

        models / providers
          https://pi.dev/packages/opencode-pi
          https://pi.dev/packages/pi-opencode-native
          https://pi.dev/packages/pi-zero
          https://pi.dev/packages/pi-free
          https://pi.dev/packages/pi-freerouter
          https://pi.dev/packages/pi-bansos

        auth
          https://pi.dev/packages/@cortexkit/pi-anthropic-auth

        themes
          https://pi.dev/packages/@zenobius/pi-rose-pine
          https://pi.dev/packages/awesome-pi-themes

        i18n / settings
          https://pi.dev/packages/@juicesharp/rpiv-i18n
          https://pi.dev/packages/@juanibiapina/pi-extension-settings
          https://pi.dev/packages/@jachy/pi-git-sync

        runtime / data
          https://pi.dev/packages/@xynogen/pix-runtime
          https://pi.dev/packages/@xynogen/pix-data
          https://pi.dev/packages/ultra-fabric

        tools
          https://pi.dev/packages/bladebro
          https://pi.dev/packages/@aliou/pi-processes
          https://pi.dev/packages/@juicesharp/rpiv-args
          https://pi.dev/packages/@4fu/pi-bin-hints

        integrations / chat
          https://pi.dev/packages/@whonixnetworks/pi-mattermost

        security / sandbox
          https://pi.dev/packages/pi-sandbox

        sessions / tmux
          https://pi.dev/packages/pi-terminal-mux
          https://pi.dev/packages/pi-jump
          https://pi.dev/packages/@robhowley/pi-session-deck

        notifications
          https://pi.dev/packages/@noice-tech/pi-terminal-bell

        notes
          tmux
          free models
          max iterations
          notifications
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
