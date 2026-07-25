{ pkgs, ... }:

{

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    baseIndex = 1;
    mouse = true;
    historyLimit = 1000000;
    escapeTime = 0;
    keyMode = "vi";
    prefix = "C-a";
    tmuxp.enable = true;

    plugins = with pkgs.tmuxPlugins; [
      fzf-tmux-url
      {
        plugin = tmux-thumbs;
        extraConfig = "set -g @thumbs-command ' pbcopy '";
      }
    ];

    extraConfig = "source-file ~/.config/tmux/tmux.conf";
  };

  xdg.configFile = {
    "tmux/tmux.conf".source = ./tmux.conf;
    "tmux/core.conf".source = ./core.conf;
    "tmux/keybindings.conf".source = ./keybindings.conf;
    "tmux/floax.conf".source = ./floax.conf;
    "tmux/fzf-sessions.conf".source = ./fzf-sessions.conf;
    "tmux/aichat.conf".source = ./aichat.conf;
    "tmux/vim_edit.conf".source = ./vim_edit.conf;
    "tmux/status.conf".source = ./status.conf;

    "tmux/scripts/aichat" = {
      source = ./scripts/aichat;
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
