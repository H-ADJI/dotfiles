{ pkgs, ... }:

{
  services.jankyborders = {
    enable = true;
    settings = {
      style = "square";
      width = 12.0;
      hidpi = "on";
      active_color = "0xff000000";
      inactive_color = "0xffcdd6f4";
    };
  };
}
