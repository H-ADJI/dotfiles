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
