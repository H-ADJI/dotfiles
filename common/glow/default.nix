{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    glow
  ];

  xdg.configFile."glow/glow.yml".source = ./glow.yml;

  # glow defaults to ~/Library/Preferences/glow on macOS
  home.file."Library/Preferences/glow/glow.yml" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    source = ./glow.yml;
  };
}
