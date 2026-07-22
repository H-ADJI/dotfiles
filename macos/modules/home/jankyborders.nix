{ pkgs, ... }:

{
  launchd.userAgents.jankyborders = {
    enable = true;
    command = "${pkgs.jankyborders}/bin/borders";
    args = [
      "--width" "8.0"
      "--active-color" "0xff89b4fa"
      "--inactive-color" "0xff45475a"
      "--hidpi" "on"
    ];
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      ProcessType = "Background";
    };
  };
}
