{
  programs.pi-coding-agent = {
    enable = true;
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
