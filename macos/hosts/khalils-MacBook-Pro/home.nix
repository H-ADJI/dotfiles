{ pkgs, ... }:

{
  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    clang
    cargo
    curl
    fd
    gh
    gnugrep
    gnutar
    go
    google-chrome
    hyperfine
    mise
    neovim
    nodejs
    opencode
    python3
    ripgrep
    rustc
    stow
    television
    tree-sitter
    uv
    zellij
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "khalil hadji";
        email = "h-adji_tech@proton.me";
      };
      alias.yolo = "!git add -A && git commit -m \"$(curl --silent --fail https://whatthecommit.com/index.txt)\"";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";

    history = {
      size = 5000;
      save = 5000;
      path = "$HOME/.zsh_history";
      append = true;
      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
      saveNoDups = true;
      findNoDups = true;
    };

    completionInit = ''
      fpath+=("${pkgs.zsh-completions}/share/zsh/site-functions")
      autoload -Uz compinit
      compinit -C
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu select
    '';

    oh-my-zsh = {
      enable = true;
      # TODO: Replace OMZ snippets with native Home Manager settings where available.
      plugins = [ "git" "sudo" "eza" "gh" "uv" "ssh" ];
    };

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    shellAliases = {
      gclean = "git clean -f";
      lc = "leetcode";
      e = "$EDITOR";
      nv = "nvim";
      nvconfig = "cd ~/.config/nvim && nv";
      tmuxconf = "nv ~/.tmux.conf";
      t = "tmuxp load -y";
      c = "clear";
      ".." = "cd ..";
      mkdir = "mkdir -pv";
      grep = "grep --color=auto";
      xcurl = "curl -x 127.0.0.1:8000 -k";
      zshconfig = "nvim ~/dotfiles/macos/hosts/khalils-MacBook-Pro/home.nix";
      zbench = "hyperfine --warmup 5 'zsh -i -c exit'";
      xel = "fc";
      dotconf = "cd ~/.config";
      nvim_shada_clear = "rm ~/.local/state/nvim/shada/main.shada";
      hd = "hunk diff";
    };

    initContent = ''
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

      export AICHAT_MESSAGES_FILE="$HOME/messages.md"
      export PATH="$PATH:$HOME/.config/scripts"
      export BAT_CONFIG_PATH="$HOME/.config/bat/bat.conf"
      export DIRENV_LOG_FORMAT=""

      if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR="vim"
      else
        export EDITOR="nvim"
      fi
      export SUDO_EDITOR="nvim"
      export VISUAL="nvim"
      export FCEDIT="nvim"

      aises() {
        aichat -s "$(basename "$(pwd)")"
      }
      aichat_hist() {
        nvim "$HOME/.aichat/$(basename "$(pwd)").md"
      }

      bindkey '^y' autosuggest-accept
      bindkey '^ ' autosuggest-execute
      bindkey '^o' forward-word
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      autoload edit-command-line
      zle -N edit-command-line
      bindkey '^E' edit-command-line
      autoload -Uz select-word-style
      select-word-style bash

      if (( $+commands[batman] )); then
        eval "$(batman --export-env)"
      fi
      if (( $+commands[zellij] )) && [[ ! -f "$HOME/.zfunc/_zellij" ]]; then
        mkdir -p "$HOME/.zfunc"
        zellij setup --generate-completion zsh >"$HOME/.zfunc/_zellij"
      fi
      # TODO: Replace manual mise, television, and Zellij shell setup with native modules if added.
      eval "$(mise activate zsh)"
      eval "$(tv init zsh)"
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    silent = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    extraPackages = [ pkgs.bat-extras.batman ];
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

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

  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      theme = "Catppuccin Latte";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 20;
      font-style = "Bold";
      font-style-bold = true;
      font-style-italic = false;
      font-style-bold-italic = false;
      resize-overlay = "never";
      title = "Ghostty";
      scrollbar = "never";
      scrollback-limit = 10000;
      confirm-close-surface = false;
      window-decoration = "none";
      maximize = false;
      window-padding-x = 180;
      window-padding-y = 80;
      keybind = [ "ctrl+shift+r=reload_config" ];
    };
  };

  home.file = {
    ".hushlogin".text = "";
    ".tmuxp".source = ../../tmux/dot-tmuxp;
  };

  xdg.configFile = {
    "nvim".source = ../../nvim/dot-config/nvim;
  };
}
