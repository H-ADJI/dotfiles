{ inputs, pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      nixosModules = "/home/khalil/dotfiles/nixos";
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
        alacritty
        bluetui
        brave
        fd
        fuzzel
        fzf
        glow
        gnugrep
        go
        google-chrome
        hunk
        hyperfine
        impala
        jnv
        jqp
        libnotify
        mpv
        nautilus
        neovim
        nerd-fonts.jetbrains-mono
        opencode
        papirus-icon-theme
        playerctl
        pulsemixer
        raffi
        ripgrep
        slurp
        socat
        tabiew
        tree
        wayscriber
        wl-clipboard
        xre
      ];
    };
  };
}
