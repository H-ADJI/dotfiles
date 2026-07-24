{ pkgs, ... }:

{
  home.file.".hushlogin".text = "";

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
      fpath=(
        "${pkgs.zsh-completions}/share/zsh/site-functions"
        "${pkgs.gh}/share/zsh/site-functions"
        "${pkgs.uv}/share/zsh/site-functions"
        "${pkgs.zellij}/share/zsh/site-functions"
        $fpath
      )
      autoload -Uz compinit
      compinit -C
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu select
    '';
    plugins = [{
      name = "fzf-tab";
      src = pkgs.zsh-fzf-tab;
      file = "share/fzf-tab/fzf-tab.plugin.zsh";
    }];
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
      zshconfig = "nvim ~/dotfiles/macos/home.nix";
      zbench = "hyperfine --warmup 5 'zsh -i -c exit'";
      xel = "fc";
      dotconf = "cd ~/.config";
      nvim_shada_clear = "rm ~/.local/state/nvim/shada/main.shada";
      hd = "hunk diff";
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gcam = "git commit -am";
      gco = "git checkout";
      gd = "git diff";
      gl = "git pull";
      gp = "git push";
      gst = "git status";
      l = "eza -lah";
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      dc = "docker compose";
      pc = "podman-compose";
    };
    initContent = ''
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
      export AICHAT_MESSAGES_FILE="$HOME/messages.md"
      export PATH="$PATH:$HOME/.config/scripts"
      export DIRENV_LOG_FORMAT=""
      if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR="vim"
      else
        export EDITOR="nvim"
      fi
      export SUDO_EDITOR="nvim"
      export VISUAL="nvim"
      export FCEDIT="nvim"
      aises() { aichat -s "$(basename "$(pwd)")"; }
      aichat_hist() { nvim "$HOME/.aichat/$(basename "$(pwd)").md"; }
      bindkey '^y' autosuggest-accept
      bindkey '^ ' autosuggest-execute
      bindkey '^o' forward-word
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[[^[' sudo-command-line
      autoload edit-command-line
      zle -N edit-command-line
      bindkey '^E' edit-command-line
      autoload -Uz select-word-style
      select-word-style bash
      if (( $+commands[batman] )); then eval "$(batman --export-env)"; fi
      # TODO: Replace manual Mise and Television shell setup with native modules if added.
      eval "$(mise activate zsh)"
      eval "$(tv init zsh)"
    '';
  };

  programs.fzf = { enable = true; enableZshIntegration = true; };
  programs.zoxide = { enable = true; enableZshIntegration = true; options = [ "--cmd" "cd" ]; };
  programs.direnv = { enable = true; enableZshIntegration = true; silent = true; };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command_timeout = 1000;
      palette = "catppuccin_latte";
      format = "$directory$git_branch$git_status$fill$python$lua$nodejs$golang$rust$package$docker_context$jobs$cmd_duration$line_break$character";
      right_format = "$all";
      fill = { symbol = " "; };
      directory = {
        style = "bold fg:lavender";
        format = "[$path ]($style)";
        truncation_length = 5;
        truncation_symbol = "…/";
        truncate_to_repo = false;
        substitutions = {
          Documents = "󰈙";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
        };
      };
      git_branch = {
        style = "fg:sapphire";
        symbol = " ";
        format = "[->](pink) [$symbol$branch ]($style)";
      };
      git_status = {
        style = "fg:red";
        conflicted = "🏳";
        ahead = "🏎💨";
        behind = "😰";
        diverged = "😵";
        up_to_date = "✓";
        stashed = "📦";
        deleted = ''[✘\($count\)](red)'';
        modified = ''📝[\($count\)](red)'';
        untracked = ''🤷[\($count\)](red)'';
        format = ''([$untracked$deleted$modified]())'';
      };
      python = {
        style = "yellow bold";
        symbol = " ";
        format = ''[''${symbol}''${pyenv_prefix}(''${version} )(\($virtualenv\) )]($style)'';
      };
      lua = { symbol = " "; };
      nodejs = { style = "blue"; symbol = " "; };
      golang = { style = "blue"; symbol = " "; };
      rust = { style = "orange"; symbol = " "; };
      ruby = { style = "blue"; symbol = " "; };
      package = { symbol = "󰏗 "; };
      docker_context = {
        symbol = " ";
        style = "fg:#06969A";
        format = "[$symbol]($style) $path";
        detect_files = [ "docker-compose.yml" "docker-compose.yaml" "Dockerfile" ];
        detect_extensions = [ "Dockerfile" ];
        disabled = true;
      };
      jobs = {
        symbol = " ";
        style = "red";
        number_threshold = 1;
        format = "[$symbol]($style)";
      };
      cmd_duration = {
        min_time = 500;
        style = "fg:gray";
        format = "[$duration]($style)";
      };
      palettes.catppuccin_latte = {
        rosewater = "#dc8a78";
        flamingo = "#dd7878";
        pink = "#ea76cb";
        mauve = "#8839ef";
        red = "#d20f39";
        maroon = "#e64553";
        peach = "#fe640b";
        yellow = "#df8e1d";
        green = "#40a02b";
        teal = "#179299";
        sky = "#04a5e5";
        sapphire = "#209fb5";
        blue = "#1e66f5";
        lavender = "#7287fd";
        text = "#4c4f69";
        subtext1 = "#5c5f77";
        subtext0 = "#6c6f85";
        overlay2 = "#7c7f93";
        overlay1 = "#8c8fa1";
        overlay0 = "#9ca0b0";
        surface2 = "#acb0be";
        surface1 = "#bcc0cc";
        surface0 = "#ccd0da";
        base = "#eff1f5";
        mantle = "#e6e9ef";
        crust = "#dce0e8";
      };
    };
  };
  programs.bat = {
    enable = true;
    extraPackages = [ pkgs.bat-extras.batman ];
    config.theme = "Catppuccin Latte";
  };
  programs.eza = { enable = true; enableZshIntegration = true; };
}
