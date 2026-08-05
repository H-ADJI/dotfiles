{
  systemd.user.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = 1;
    OZONE_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XCURSOR_SIZE = 24;
    XCURSOR_THEME = "catppuccin-latte-light-cursors";
    HYPRCURSOR_THEME = "catppuccin-latte-light-cursors";
    HYPRCURSOR_SIZE = 44;
    EDITOR = "nvim";
  };
}
