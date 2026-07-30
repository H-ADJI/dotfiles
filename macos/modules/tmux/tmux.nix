{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    # Core settings are sourced from ~/.config/tmux/core.conf
    tmuxp.enable = true;
    plugins = with pkgs.tmuxPlugins; [
      fzf-tmux-url
      {
        plugin = tmux-thumbs;
        extraConfig = "set -g @thumbs-command ' pbcopy '";
      }
    ];
  };

  xdg.configFile = {
    "tmux/tmux.conf".source = ./tmux.conf;
    "tmux/core.conf".source = ./core.conf;
    "tmux/keybindings.conf".source = ./keybindings.conf;
    "tmux/floax.conf".source = ./floax.conf;
    "tmux/fzf-sessions.conf".source = ./fzf-sessions.conf;
    "tmux/md_preview.conf".source = ./md_preview.conf;
    "tmux/vim_edit.conf".source = ./vim_edit.conf;
    "tmux/status.conf".source = ./status.conf;

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
