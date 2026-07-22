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
      zshconfig = "nvim ~/dotfiles/macos/hosts/khalils-MacBook-Pro/home.nix";
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
  programs.starship = { enable = true; enableZshIntegration = true; };
  programs.bat = { enable = true; extraPackages = [ pkgs.bat-extras.batman ]; };
  programs.eza = { enable = true; enableZshIntegration = true; };
}
