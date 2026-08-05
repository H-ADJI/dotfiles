{ ... }:
{
  programs.satty = {
    enable = true;
    settings = {
      general = {
        fullscreen = false;
        disable-notifications = true;
        early-exit = [ "all" ];
        initial-tool = "brush";
      };
    };
  };
}
