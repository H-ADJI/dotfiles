{ pkgs, ... }:
{
  programs.pi-coding-agent = {
    enable = true;
    extraPackages = [
      pkgs.nodejs
      pkgs.bun
    ];
    settings = {
      # TODO: tui rice
      # status-line / footer
      # plan-mode
      # context inspection
      # last message popup viewer
      # last message popup viewer
      # btw
      # skills : github repo
      # skills : review - annotations
      # skills : refactor - improve
      # skills : token efficiency
      # max iterations
      # notifications
      # user questions : https://pi.dev/packages/@juicesharp/rpiv-ask-user-question
      # todo list : https://pi.dev/packages/@juicesharp/rpiv-todo
      # https://pi.dev/packages/@mjasnikovs/pi-task
      # https://pi.dev/packages/@dietrichgebert/ponytail
      # https://pi.dev/packages/@plannotator/pi-extension
      # https://pi.dev/packages/pi-powerline-footer
      # https://pi.dev/packages/bigpowers

      packages = [
        "npm:@narumitw/pi-plan-mode"
        "npm:@narumitw/pi-tool"
      ];
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
