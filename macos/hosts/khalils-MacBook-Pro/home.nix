{ pkgs, ... }:

{
  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    tmux
    tmuxp
  ];

  programs.git = {
    enable = true;
    userName = "khalil hadji";
    userEmail = "h-adji_tech@proton.me";
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
      };
    };
    aliases.yolo = "!git add -A && git commit -m \"$(curl --silent --fail https://whatthecommit.com/index.txt)\"";
    extraConfig = {
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  home.file = {
    ".zshrc".source = ../../zsh/dot-zshrc;
    "zsh".source = ../../zsh/zsh;
    ".tmux.conf".source = ../../tmux/dot-tmux.conf;
    ".tmuxp".source = ../../tmux/dot-tmuxp;
  };

  xdg.configFile = {
    "ghostty".source = ../../ghostty/dot-config/ghostty;
    "nvim".source = ../../nvim/dot-config/nvim;
  };
}
