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
    hyperfine
    mise
    neovim
    nodejs
    python3
    ripgrep
    rustc
    stow
    television
    tree-sitter
    tmux
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

  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      theme = "Catppuccin Latte";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 15;
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
      window-padding-x = 24;
      window-padding-y = 16;
      keybind = [ "ctrl+shift+r=reload_config" ];
    };
  };

  programs.tmux.tmuxp.enable = true;

  home.file = {
    ".tmux.conf".source = ../../tmux/dot-tmux.conf;
    ".tmuxp".source = ../../tmux/dot-tmuxp;
  };

  xdg.configFile = {
    "nvim".source = ../../nvim/dot-config/nvim;
  };
}
