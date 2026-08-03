{ pkgs, ... }:

{
  home.packages = with pkgs; [ zinit ];

  xdg.configFile."zinit/zinit.sh".text = ''
    source ${pkgs.zinit}/share/zinit/zinit.zsh
    zinit light "mroth/evalcache"
    zinit snippet OMZL::git.zsh
    zinit snippet OMZP::git
    zinit snippet OMZP::sudo
    zinit snippet OMZP::eza
    zinit snippet OMZP::gh
    zinit snippet OMZP::uv
    zinit snippet OMZP::ssh
    zinit snippet OMZP::docker
    zinit snippet OMZP::docker-compose
    zinit snippet OMZP::podman
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
    FCEDIT = "nvim";
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

    # TODO: mise completion to be added
    completionInit = ''
      fpath+=(
        "${pkgs.zsh-completions}/share/zsh/site-functions"
        "${pkgs.gh}/share/zsh/site-functions"
        "${pkgs.uv}/share/zsh/site-functions"
      )
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu select
    '';

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
      t = "tmuxp load -y";
      c = "clear";
      ".." = "cd ..";
      mkdir = "mkdir -pv";
      grep = "grep --color=auto";
      xcurl = "curl -x 127.0.0.1:8000 -k ";
      zbench = "hyperfine --warmup 5 'zsh -i -c exit'";
      xel = "fc";
      dotconf = "cd ~/.config";
      nvim_shada_clear = "rm ~/.local/state/nvim/shada/main.shada";
      hd = "hunk diff";
      nb = "sudo nixos-rebuild switch --flake ./nixos#nixos";
    };

    initContent = builtins.readFile ./zshrc;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = false;
    options = [
      "--cmd"
      "cd"
    ];
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = false;
    silent = true;
  };
  programs.bat = {
    enable = true;
    extraPackages = [ pkgs.bat-extras.batman ];
    config.theme = "Catppuccin Latte";
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}
