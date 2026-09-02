{ config, inputs, pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      nixosModules = "${config.home-manager.users.khalil.home.homeDirectory}/PDE/nixos";
      inherit inputs;
    };
    users.khalil = {
      imports = [
        ./alacritty
        ./voxtype
        ./assets
        ./direnv
        ./fastfetch
        ./fuzzel
        ./ghostty
        ./git
        ./glow
        ./gtk
        ./hunk
        ./hyprland
        ./jnv
        ./jqp
        ./mise
        ./nh
        ./noctalia
        ./nvim
        ./opencode
        ./pi-agent
        ./pulsemixer
        ./raffi
        ./satty
        ./share-picker
        ./ssh
        ./starship
        ./systemd
        ./tabiew
        ./taskwarrior
        ./television
        ./tmux
        ./wayscriber
        ./xdg
        ./yazi
        ./zathura
        ./zsh
      ];
      home.username = "khalil";
      home.homeDirectory = "/home/khalil";
      home.stateVersion = "26.05";
      home.packages = with pkgs; [
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
    };
  };
}
