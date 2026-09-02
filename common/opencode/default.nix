{
  xdg.configFile."opencode/opencode.json".source = ./opencode.json;
  xdg.configFile."opencode/tui.json".source = ./tui.json;
  programs.opencode = {
    enable = true;
  };
}
