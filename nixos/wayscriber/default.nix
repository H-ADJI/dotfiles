{ pkgs, ... }:
{
  home.packages = with pkgs; [ wayscriber ];
  xdg.desktopEntries.wayscriber = {
    name = "Wayscriber";
    genericName = "Screen Annotation";
    comment = "Annotate your screen on Wayland";
    exec = "wayscriber --active";
    icon = "draw-brush";
    categories = [ "Graphics" ];
  };
}
