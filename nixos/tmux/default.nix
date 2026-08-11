{
  programs.tmux = {
    enable = true;
    # Core settings are sourced from ~/.config/tmux/core.conf
    tmuxp.enable = true;
  };

  xdg.configFile = {
    "tmux/tmux.conf".source = ./tmux.conf;
    "tmux/status-bar.conf".source = ./status-bar.conf;

    "tmux/scripts/md_preview" = {
      source = ./scripts/md_preview;
      executable = true;
    };
    "tmux/scripts/vim_edit" = {
      source = ./scripts/vim_edit;
      executable = true;
    };
    "tmux/scripts/floax-toggle" = {
      source = ./scripts/floax-toggle;
      executable = true;
    };
    "tmux/scripts/switch-session" = {
      source = ./scripts/switch-session;
      executable = true;
    };
  };

  xdg.configFile."tmuxp".source = ./sessions;

}
