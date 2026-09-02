{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./aerospace
    ./alacritty
    ./colima
    ./direnv
    ./desktoppr
    ./fastfetch
    ./ghostty
    ./git
    ./glow
    ./hunk
    ./jnv
    ./jqp
    ./mise
    ./nh
    ./nvim
    ./opencode
    ./packages
    ./ssh
    ./starship
    ./tabiew
    ./taskwarrior
    ./television
    ./tmux
    ./yazi
    ./zsh
  ];

  home.username = "khalil";
  home.homeDirectory = "/Users/khalil";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    brave
  ];
}
