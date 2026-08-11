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
        ./modules/alacritty
        ./modules/assets
        ./modules/herdr
        ./modules/fastfetch
        ./modules/fuzzel
        ./modules/ghostty
        ./modules/git
        ./modules/glow
        ./modules/gtk
        ./modules/hunk
        ./modules/hyprland
        ./modules/jnv
        ./modules/jqp
        ./modules/nh
        ./modules/noctalia
        ./modules/nvim
        ./modules/opencode
        ./modules/pulsemixer
        ./modules/raffi
        ./modules/satty
        ./modules/ssh
        ./modules/starship
        ./modules/systemd
        ./modules/tabiew
        ./modules/taskwarrior
        ./modules/television
        ./modules/tmux
        ./modules/wayscriber
        ./modules/xdg
        ./modules/yazi
        ./modules/zathura
        ./modules/zsh
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
