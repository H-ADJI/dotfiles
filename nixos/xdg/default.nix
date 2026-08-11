{
  xdg = {
    enable = true;
    mime = {
      enable = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "brave.desktop";
        "x-scheme-handler/http" = "brave.desktop";
        "x-scheme-handler/https" = "brave.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/png" = "satty.desktop";
        "x-scheme-handler/mailto" = "brave.desktop";
        "x-scheme-handler/terminal" = "org.alacritty.Alacritty.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "video/*" = "io.mpv.Mpv.desktop";
        "audio/*" = "io.mpv.Mpv.desktop";
      };
    };
  };
}
