{ inputs, pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      nixosModules = "/home/khalil/dotfiles/nixos/modules";
      inherit inputs;
    };
    users.khalil = {
      imports = [
        inputs.noctalia.homeModules.default
        ./alacritty
        ./assets
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
        ./nh
        ./noctalia
        ./nvim
        ./opencode
        ./pulsemixer
        ./raffi
        ./satty
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
        nerd-fonts.jetbrains-mono
        glow
        alacritty
        raffi
        go
        wl-clipboard
        google-chrome
        brave
        neovim
        fuzzel
        tree
        fd
        fzf
        gnugrep
        hyperfine
        ripgrep
        pulsemixer
        libnotify
        opencode
        mpv
        nautilus
        playerctl
        papirus-icon-theme
        wayscriber
        bluetui
        impala
        socat
        hunk
        jnv
        jqp
        tabiew
        slurp
      ];
    };
  };
}
