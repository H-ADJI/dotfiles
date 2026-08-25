{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xre
  ];
  programs.tmux = {
    enable = true;
    tmuxp.enable = true;
  };

  xdg.configFile = {
    "tmux/tmux.conf".source = ./tmux.conf;

    "tmux/scripts/md_preview" = {
      source = ./scripts/md_preview;
      executable = true;
    };
    "tmux/scripts/vim_edit" = {
      source = ./scripts/vim_edit;
      executable = true;
    };
    "tmux/scripts/floating-pane" = {
      source = ./scripts/floating-pane;
      executable = true;
    };
  };

  xdg.configFile."tmuxp".source = ./sessions;

}
