{
  pkgs,
  ...
}:
{
  imports = [
    ../common/alacritty
    ../common/direnv
    ../common/fastfetch
    ../common/ghostty
    ../common/git
    ../common/glow
    ../common/hunk
    ../common/jnv
    ../common/jqp
    ../common/mise
    ../common/nh
    ../common/nvim
    ../common/opencode
    ../common/pi-agent
    ../common/ssh
    ../common/starship
    ../common/tabiew
    ../common/taskwarrior
    ../common/television
    ../common/tmux
    ../common/yazi
    ../common/zsh
    ./aerospace
    ./colima
    ./ghostty
    ./zsh
  ];

  home = {
    username = "khalil";
    homeDirectory = "/Users/khalil";
    stateVersion = "26.05";
    file.".hushlogin".text = "";
    packages = with pkgs; [
      docker
      docker-compose
      podman
      podman-compose
      google-chrome
      brave
      nerd-fonts.jetbrains-mono
    ];
  };
}
