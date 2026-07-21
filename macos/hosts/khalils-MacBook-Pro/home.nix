{ pkgs, ... }:

{
  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    tmux
    tmuxp
  ];

  home.file = {
    ".gitconfig".source = ../../git/dot-gitconfig;
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
