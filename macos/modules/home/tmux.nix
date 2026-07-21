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
      sensible
      fzf-tmux-url
      {
        plugin = tmux-thumbs;
        extraConfig = "set -g @thumbs-command ' pbcopy '";
      }
      {
        plugin = tmux-floax;
        extraConfig = ''
          set -g @floax-bind '-n M-p'
          set -g @floax-title 'Floating Terminal'
          set -g @floax-session-name 'floax-session'
          set -g @floax-change-path 'false'
        '';
      }
    ];
    # TODO: Package or replace unavailable tmux-fzf-session-switch plugin.
    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g detach-on-destroy on
      set -g renumber-windows on
      set -g set-clipboard on

      bind C-h select-pane -L
      bind C-j select-pane -D
      bind C-k select-pane -U
      bind C-l select-pane -R
      bind | splitw -h
      bind _ splitw -v
      bind h previous-window
      bind l next-window
      bind-key -n M-s copy-mode
      bind C-q kill-session
      unbind q
      bind q kill-window
      bind e run "sh -c ~/.config/scripts/vim_edit"
      bind m run "sh -c ~/.config/scripts/aichat"

      set -g @text_color "#000000"
      set -g @inactive_color "#cdd6f4"
      set -g @active_color "#a6adc8"
      set -g @session_color "#89b4fa"
      set -g @prefix_color "#f38ba8"
      set -g @left_bubble_color "#a6e3a1"
      set -g status-position top
      set -g status-justify "absolute-centre"
      set -g status 2
      set -g status-style "bg=default,fg=default"
      set -g status-format[1] " "
      set -g window-status-style "bg=default,fg=default"
      set -g window-status-current-style "bg=default,fg=default"
      set -g window-status-format "\
      #[fg=#{@inactive_color},bg=default]\
      #[fg=#{@text_color},bg=#{@inactive_color}] #W \
      #[fg=#{@inactive_color},bg=default]"
      set -g window-status-current-format "\
      #[fg=#{@active_color},bg=default]\
      #[fg=#{@text_color},bg=#{@active_color},bold] #W \
      #[fg=#{@active_color},bg=default]"
      set -g status-right "\
      #[fg=#{?client_prefix,#{@prefix_color},#{@session_color}},bg=default]\
      #[fg=#{@text_color},bg=#{?client_prefix,#{@prefix_color},#{@session_color}}]  #S \
      #[fg=#{?client_prefix,#{@prefix_color},#{@session_color}},bg=default]  "
      set -g status-left "\
      #[fg=#{@left_bubble_color},bg=default]\
      #[fg=#{@text_color},bg=#{@left_bubble_color}] 󰓩 #(tmux list-sessions | wc -l | tr -d '[:space:]') \
      #[fg=#{@left_bubble_color},bg=default]"
    '';
  };
}
