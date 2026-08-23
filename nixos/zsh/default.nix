{ pkgs, ... }:
{
  home.packages = with pkgs; [ zinit ];

  xdg.configFile."zinit/zinit.sh".text = ''
    source ${pkgs.zinit}/share/zinit/zinit.zsh
    zinit light "mroth/evalcache"
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
      append = true;
      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
      saveNoDups = true;
      findNoDups = true;
    };

    completionInit = ''
      fpath+=(
        "${pkgs.zsh-completions}/share/zsh/site-functions"
        "${pkgs.gh}/share/zsh/site-functions"
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
      gsw = "git switch";
      gclean = "git clean -f";
      grs = "git restore";
      ga = "git add";
      gaa = "git add --all";
      gst = "git status";
      gss = "git status --short";
      gcam = "git commit -a -m";
      gcmsg = "git commit -m";
      gl = "git pull";
      gp = "git push";
      gd = "git diff";
      gds = "git diff --staged";
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
      nix_switch = "sudo nixos-rebuild switch --flake ~/PDE/nixos#nixos";
      nh_clean = "nh clean all --keep 3";
      nh_switch = "nh os switch --accept-flake-config";
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
