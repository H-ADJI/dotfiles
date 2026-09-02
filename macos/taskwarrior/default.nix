{
  programs.taskwarrior = {
    enable = true;
    colorTheme = "light-256";
    extraConfig = ''
      news.version=3.4.2
    '';
    config = {
      confirmation = false;
    };
  };
}
