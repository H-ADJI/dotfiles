{ inputs, pkgs, ... }:
let
  hyprlandPreviewSharePickerSrc = pkgs.fetchgit {
    url = "https://github.com/WhySoBad/hyprland-preview-share-picker";
    rev = "e2f30ff85486e557018523da45ccbc846e3a499c";
    sha256 = "sha256-XE6RD/4Mhw/ZRBj0v94kLOERElat5V+e/X0L9eUGf7M=";
    fetchSubmodules = true;
  };
  hyprlandPreviewSharePicker = pkgs.callPackage "${hyprlandPreviewSharePickerSrc}/package.nix" {
    rev = "e2f30ff85486e557018523da45ccbc846e3a499c";
  };
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      nixosModules = "/home/khalil/PDE/nixos";
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
        ./share-picker
        ./systemd
        ./pi-agent
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
        hyprlandPreviewSharePicker
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
        ardour
      ];
    };
  };
}
