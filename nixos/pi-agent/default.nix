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
    "${config.programs.pi-coding-agent.configDir}/deepseek-tier.json".source =
      config.lib.file.mkOutOfStoreSymlink "${piAgentModule}/agent/deepseek-tier.json";
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

  /*
    packages catalog (mostly commented out; active ones are in settings.json)

    inspect all context
    cost timeline

    modern CLIs
    ast-grep + ripgrep
    rtk

    advisor
    plan mode
    todos
    reviewer
    refactor
    simplify

    visual-explainer
    archify
    lavish
    crew mates
    subagents

    web search : donsetch
    browser automation : bladebro

    token efficiency
    prompts

    notifications
    tmux integration

    guardrails
    sandbox
    anthropic auth
    free models

    packages
    https://pi.dev/packages/opencode-pi
    https://pi.dev/packages/pi-opencode-native
    https://pi.dev/packages/pi-zero
    https://pi.dev/packages/pi-free
    https://pi.dev/packages/pi-freerouter
    https://pi.dev/packages/pi-bansos
    "npm:@narumitw/pi-plan-mode"
    "npm:@zenspc/pi-workflow"

    plan / task / goals
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
  programs.pi-coding-agent = {
    enable = true;
    extraPackages = [
      pkgs.nodejs
    ];
  };
}
