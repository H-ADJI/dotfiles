{
  inputs,
  pkgs,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };
    users.khalil = {
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
        ./ghostty
        ./voxtype
        ./assets
        ./fuzzel
        ./gtk
        ./hyprland
        ./noctalia
        ./pulsemixer
        ./raffi
        ./satty
        ./share-picker
        ./systemd
        ./wayscriber
        ./xdg
        ./zathura
      ];
      home = {
        homeDirectory = "/home/khalil";
        packages = with pkgs; [
          # TODO: package : shuck / zshcs
          bluetui
          fd
          fzf
          gnugrep
          google-chrome
          htmlq
          hyperfine
          impala
          libnotify
          nerd-fonts.jetbrains-mono
          playerctl
          ripgrep
          slurp
          socat
          tree
          vial
          wl-clipboard
        ];
        stateVersion = "26.05";
        username = "khalil";
      };
    };
  };
}
